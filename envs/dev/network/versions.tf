# ----------------------------------------------------------------------------
# versions.tf (dev / network)
#
# Pins the tool versions, and says WHERE this stack's memory (state) lives:
#   bucket = the shared notebook in S3
#   key    = this stack's own page: dev/network/terraform.tfstate
#   use_lockfile = S3 native locking, so only one run can change this stack at a time
# ----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "us-staffing-tfstate-061624868468-ap-south-1"
    key          = "dev/network/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
