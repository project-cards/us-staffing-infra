# ----------------------------------------------------------------------------
# outputs.tf (dev / network)
#
# Printed after apply, and readable by later dev stacks (EKS and database).
# ----------------------------------------------------------------------------

output "vpc_id" {
  description = "Dev VPC ID."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Dev public subnet IDs."
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "Dev app subnet IDs. EKS nodes run here."
  value       = module.network.app_subnet_ids
}

output "db_subnet_ids" {
  description = "Dev database subnet IDs."
  value       = module.network.db_subnet_ids
}
