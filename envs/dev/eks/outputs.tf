# ----------------------------------------------------------------------------
# outputs.tf (dev / eks)
# ----------------------------------------------------------------------------

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "node_role_arn" {
  value = module.eks.node_role_arn
}

output "cluster_security_group_id" {
  description = "Passed to the data stack, so the database can allow the worker nodes."
  value       = module.eks.cluster_security_group_id
}
