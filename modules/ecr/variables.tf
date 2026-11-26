# ----------------------------------------------------------------------------
# variables.tf (module: ecr)
# ----------------------------------------------------------------------------

variable "repo_names" {
  description = "Names of the image repositories, one per app."
  type        = list(string)
  default     = ["us-staffing-api", "us-staffing-ui"]
}

variable "kms_key_arn" {
  description = "KMS key that encrypts the images (the same key as the state)."
  type        = string
}

variable "tags" {
  description = "Tags added to every repository."
  type        = map(string)
  default     = {}
}
