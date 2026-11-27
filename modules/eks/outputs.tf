# ----------------------------------------------------------------------------
# outputs.tf (module: eks)
# ----------------------------------------------------------------------------

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_arn" {
  value = aws_eks_cluster.this.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.cluster.arn
}

output "node_role_arn" {
  value = aws_iam_role.node.arn
}

output "node_group_name" {
  value = aws_eks_node_group.general.node_group_name
}

output "cluster_security_group_id" {
  description = "The security group EKS attaches to the worker nodes. The database allows port 5432 from this group."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
