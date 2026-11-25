# ----------------------------------------------------------------------------
# lock.tf
#
# Calls the tfstate-lock-dynamodb module to create the lock table.
#
# Simple version: a module is a reusable building block. This stack says
# "build one lock table, encrypted with the same key as the state bucket".
# Other stacks that want DynamoDB locking point their backend at the table name.
# ----------------------------------------------------------------------------

module "tfstate_lock" {
  source = "../../modules/tfstate-lock-dynamodb"

  table_name  = "us-staffing-tfstate-lock"
  kms_key_arn = aws_kms_key.tfstate.arn
}

output "lock_table_name" {
  description = "Use as dynamodb_table in a stack's backend block (legacy locking)."
  value       = module.tfstate_lock.table_name
}
