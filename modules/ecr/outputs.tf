# ----------------------------------------------------------------------------
# outputs.tf (module: ecr)
# The repository URLs the pipelines push to, keyed by repo name.
# ----------------------------------------------------------------------------

output "repository_urls" {
  description = "Repository URL for each app, keyed by repo name."
  value       = { for k, r in aws_ecr_repository.app : k => r.repository_url }
}
