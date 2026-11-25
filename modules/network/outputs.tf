# ----------------------------------------------------------------------------
# outputs.tf (module: network)
#
# The IDs other stacks need. The EKS and database stacks read these values
# from this stack's state file, so they never have to guess the IDs.
# ----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The VPC's address range."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs, one per zone."
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "App subnet IDs, one per zone. EKS nodes run here."
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "Database subnet IDs, one per zone. RDS runs here."
  value       = aws_subnet.db[*].id
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs (one, or one per zone)."
  value       = aws_nat_gateway.this[*].id
}
