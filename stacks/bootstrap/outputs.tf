# ----------------------------------------------------------------------------
# outputs.tf
#
# Values printed at the end of `terraform apply`. They can also be read by other
# stacks (for example, the network stack needs the state bucket name).
# Outputs never change AWS resources; they only report values.
# ----------------------------------------------------------------------------

output "state_bucket" {
  description = "Name of the Terraform state bucket. Copy this into the backend block of every later stack."
  value       = aws_s3_bucket.tfstate.bucket
}

output "kms_key_arn" {
  description = "ARN of the KMS key that encrypts the state bucket. Useful to confirm encryption is set."
  value       = aws_kms_key.tfstate.arn
}

output "account_id" {
  description = "AWS account ID this stack ran in. Check it matches the account you expect before applying."
  value       = data.aws_caller_identity.current.account_id
}
