# ----------------------------------------------------------------------------
# providers.tf
#
# How Terraform connects to AWS. Same as the bootstrap stack.
# Locally, export AWS_PROFILE=practice first. In the pipeline, OIDC provides the login.
# ----------------------------------------------------------------------------

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project    = "us-staffing"
      owner      = "pavan"
      managed_by = "terraform"
      stack      = "bootstrap-oidc"
    }
  }
}
