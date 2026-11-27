# ----------------------------------------------------------------------------
# outputs.tf (dev / data)
# ----------------------------------------------------------------------------

output "endpoint" {
  value = module.data.endpoint
}

output "port" {
  value = module.data.port
}

output "secret_arn" {
  value = module.data.secret_arn
}
