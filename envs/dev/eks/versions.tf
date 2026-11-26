# ----------------------------------------------------------------------------
# versions.tf (dev / eks)
# State: dev/eks/terraform.tfstate, with S3 native locking.
# ----------------------------------------------------------------------------

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "us-staffing-tfstate-061624868468-ap-south-1"
    key          = "dev/eks/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
