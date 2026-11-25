# ----------------------------------------------------------------------------
# main.tf (module: network)
#
# Builds one VPC: the private network that holds the EKS cluster and the database.
#
# Simple picture (a city with three districts):
#   - PUBLIC districts: the front doors. Load balancers and the NAT gateway live here.
#   - APP districts:    the workplaces. EKS worker nodes and pods live here.
#                       They reach the internet only through the NAT (one-way door out).
#   - DATABASE districts: the vault. No route to the internet at all.
#
# The module is generic: the caller passes in names, ranges and zones. Dev and prod
# call it with different values, so the same code builds both.
# ----------------------------------------------------------------------------

# The city boundary. Every other resource lives inside this range.
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  # Lets resources resolve AWS service names (needed by EKS and endpoints).
  enable_dns_support = true

  # Gives each resource a DNS name, which EKS and RDS use.
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${var.name}-vpc" })
}

# The gate to the internet. Public districts route to it.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-igw" })
}

# ----------------------------------------------------------------------------
# SUBNETS: the districts. One of each kind per zone.
#
# count = length(var.azs) makes one subnet per zone. count.index is the zone number
# (0 = first zone, 1 = second zone), and it picks the matching range from the list.
#
# The Kubernetes tags let the EKS load balancer controller find the right subnets:
#   kubernetes.io/role/elb          = public subnets for internet-facing load balancers
#   kubernetes.io/role/internal-elb = app subnets for internal load balancers
# ----------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  # Nothing gets a public IP automatically. The load balancer gets its own address.
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name                     = "${var.name}-public-${var.azs[count.index]}"
    tier                     = "public"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "app" {
  count = length(var.azs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, {
    Name                              = "${var.name}-app-${var.azs[count.index]}"
    tier                              = "app"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_subnet" "db" {
  count = length(var.azs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, {
    Name = "${var.name}-db-${var.azs[count.index]}"
    tier = "database"
  })
}

# ----------------------------------------------------------------------------
# NAT GATEWAY: the one-way door out for the app districts.
#
# Why: the worker nodes need to download images and reach AWS APIs, but nothing
# outside should be able to start a connection into them.
#
# single_nat_gateway = true  -> one NAT in the first zone (cheaper, used for dev).
#                              If that zone fails, the other zone loses outbound access.
# single_nat_gateway = false -> one NAT per zone (used for prod).
# ----------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count = var.single_nat_gateway ? 1 : length(var.azs)

  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.name}-nat-eip-${count.index}" })
}

resource "aws_nat_gateway" "this" {
  count = var.single_nat_gateway ? 1 : length(var.azs)

  # The NAT must sit in a public subnet, because it needs the internet gateway.
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  # Create the internet gateway first, or the NAT has no way out.
  depends_on = [aws_internet_gateway.this]

  tags = merge(var.tags, { Name = "${var.name}-nat-${count.index}" })
}

# ----------------------------------------------------------------------------
# ROUTE TABLES: the road signs. Each one says where traffic should go.
# ----------------------------------------------------------------------------

# Public: anything going to the internet ("0.0.0.0/0") goes to the internet gateway.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# App: one route table per zone. Internet traffic goes out through a NAT.
# The NAT index is 0 when there is a single NAT, otherwise the same zone's NAT.
resource "aws_route_table" "app" {
  count = length(var.azs)

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-app-rt-${var.azs[count.index]}" })
}

resource "aws_route" "app_nat" {
  count = length(var.azs)

  route_table_id         = aws_route_table.app[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[var.single_nat_gateway ? 0 : count.index].id
}

resource "aws_route_table_association" "app" {
  count = length(var.azs)

  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}

# Database: one shared route table with NO route to the internet.
# A database that cannot reach the internet cannot be reached from it either.
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-db-rt" })
}

resource "aws_route_table_association" "db" {
  count = length(var.azs)

  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db.id
}

# ----------------------------------------------------------------------------
# S3 GATEWAY ENDPOINT: a private road to S3.
#
# Why: without it, S3 traffic from the app subnets goes through the NAT and is billed
# as NAT data. With it, traffic stays on AWS's network, and the endpoint is free.
# It's attached to the app and database route tables, so both can use it.
# ----------------------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = concat(aws_route_table.app[*].id, [aws_route_table.db.id])

  tags = merge(var.tags, { Name = "${var.name}-s3-endpoint" })
}
