# ----------------------------------------------------------------------------
# outputs.tf (shared / ecr)
# Printed after apply: the repository URLs the pipelines push to.
# ----------------------------------------------------------------------------

output "repository_urls" {
  description = "Repository URL for each app."
  value       = module.ecr.repository_urls
}
