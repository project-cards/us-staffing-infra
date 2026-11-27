# ----------------------------------------------------------------------------
# outputs.tf (module: data)
# ----------------------------------------------------------------------------

output "endpoint" {
  description = "The database address the app connects to (resolves to a private IP)."
  value       = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "secret_arn" {
  description = "Secrets Manager secret that holds the master password."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}

output "security_group_id" {
  value = aws_security_group.db.id
}
