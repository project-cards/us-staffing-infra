# ----------------------------------------------------------------------------
# variables.tf (module: tfstate-lock-dynamodb)
#
# Inputs the caller must or may provide.
# ----------------------------------------------------------------------------

variable "table_name" {
  description = "Name of the lock table. Stacks point at this name in their backend block (dynamodb_table)."
  type        = string
  default     = "us-staffing-tfstate-lock"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key that encrypts the lock table. Use the same key as the state bucket."
  type        = string
}

variable "tags" {
  description = "Extra tags added to the table."
  type        = map(string)
  default     = {}
}
