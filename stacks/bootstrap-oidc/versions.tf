# ----------------------------------------------------------------------------
# versions.tf
#
# Same idea as the bootstrap stack: pin the Terraform and AWS provider versions.
# This stack creates the roles the pipeline uses to log in to AWS.
# ----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # The state for this stack lives in the bucket that the bootstrap created.
  # Simple version: the bucket is the shared notebook, and this stack writes its own page.
  backend "s3" {
    bucket       = "us-staffing-tfstate-061624868468-ap-south-1"
    key          = "bootstrap-oidc/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true # S3 native locking: stops two runs changing this stack at once
  }
}
