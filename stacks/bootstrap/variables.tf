# ----------------------------------------------------------------------------
# variables.tf
#
# Inputs to this stack. Each variable has:
#   - a description (what it is for)
#   - a type (what values are allowed)
#   - a default (used when nothing else is provided)
#
# You can override a value without editing this file, in one of these ways:
#   terraform apply -var="region=ap-south-1"
#   or put it in a terraform.tfvars file (one file per environment later)
#   or set TF_VAR_region in the environment (used by the pipeline)
# ----------------------------------------------------------------------------

variable "region" {
  description = "AWS region where the state bucket and its KMS key are created."
  type        = string
  default     = "ap-south-1" # Mumbai. Matches the region used for the rest of the project.
}

variable "profile" {
  description = "AWS CLI profile name. Leave null in the pipeline; use AWS_PROFILE on your laptop."
  type        = string
  default     = null # Null means "use the normal credential chain". Keeps profile names out of the code.
}

variable "state_bucket_name" {
  description = <<-EOT
    Name of the S3 bucket that stores Terraform state.
    S3 bucket names are unique across ALL AWS accounts, so the name includes
    the account ID and the region to make it unlikely to clash with anyone else.
  EOT
  type        = string
  default     = "us-staffing-tfstate-061624868468-ap-south-1"
}
