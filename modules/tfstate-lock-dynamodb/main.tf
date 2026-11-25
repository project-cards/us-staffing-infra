# ----------------------------------------------------------------------------
# main.tf (module: tfstate-lock-dynamodb)
#
# Creates the DynamoDB table used for the OLDER style of Terraform locking.
#
# Simple picture: the table is the "in use" sign board. When a Terraform run
# starts, it writes one row here. Another run that tries to start finds the row
# and stops. When the run finishes, the row is deleted.
#
# Note: this is the legacy approach. The current approach is S3 native locking
# (use_lockfile = true). We build this module to learn it and to support older
# stacks.
# ----------------------------------------------------------------------------

resource "aws_dynamodb_table" "lock" {
  name = var.table_name

  # PAY_PER_REQUEST: you pay per lock operation, not for reserved capacity.
  # Locks are written only a few times per run, so this costs cents per month.
  billing_mode = "PAY_PER_REQUEST"

  # Terraform requires exactly this key name. It stores the path of the state
  # file, so every stack gets its own row.
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S" # S = string
  }

  # Encrypt the lock rows with our KMS key, the same key that protects the state.
  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  # Backups: lets you restore the table to any point in the last 35 days.
  point_in_time_recovery {
    enabled = true
  }

  # Stops `terraform destroy` or a console click from deleting the table while
  # stacks depend on it.
  deletion_protection_enabled = true

  tags = var.tags
}
