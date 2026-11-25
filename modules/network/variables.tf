# ----------------------------------------------------------------------------
# variables.tf (module: network)
#
# The inputs the caller must give. There are no defaults for the ranges on purpose:
# the caller must decide them, so a dev and prod mix-up can't happen silently.
# ----------------------------------------------------------------------------

variable "name" {
  description = "Short name used in every resource name, for example us-staffing-dev."
  type        = string
}

variable "region" {
  description = "AWS region. Used to build the S3 endpoint name."
  type        = string
}

variable "vpc_cidr" {
  description = "The VPC's address range, for example 10.10.0.0/16. It must not overlap any other network."
  type        = string
}

variable "azs" {
  description = "Availability zones to use, for example [ap-south-1a, ap-south-1b]. One subnet of each kind is made per zone."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "One range per zone for the public subnets. Same order as azs."
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "One range per zone for the app subnets (EKS nodes and pods). Same order as azs."
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "One range per zone for the database subnets. Same order as azs."
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "true: one NAT gateway (cheaper, dev). false: one NAT per zone (prod)."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags added to every resource."
  type        = map(string)
  default     = {}
}
