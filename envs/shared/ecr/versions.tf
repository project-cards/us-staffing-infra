# ----------------------------------------------------------------------------
# versions.tf (shared / ecr)
#
# Shared by dev and prod, so its state is not under dev/ or prod/.
# Its state key: shared/ecr/terraform.tfstate, with S3 native locking.
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
    key          = "shared/ecr/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
