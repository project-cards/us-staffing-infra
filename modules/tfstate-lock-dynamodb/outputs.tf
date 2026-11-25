# ----------------------------------------------------------------------------
# outputs.tf (module: tfstate-lock-dynamodb)
#
# Values the caller can use, for example the table name for a backend block.
# ----------------------------------------------------------------------------

output "table_name" {
  description = "Use this as dynamodb_table in a stack's backend block."
  value       = aws_dynamodb_table.lock.name
}

output "table_arn" {
  description = "ARN of the lock table."
  value       = aws_dynamodb_table.lock.arn
}
