# ----------------------------------------------------------------------------
# versions.tf
#
# Pins the Terraform version and the provider versions this stack needs.
# Pinning matters: a new provider release can change behaviour, and without a
# pin, your code could break the day someone runs it on a fresh machine.
#
# Where things live in a Terraform stack:
#   versions.tf   -> which Terraform and provider versions to use (this file)
#   providers.tf  -> how to connect to AWS (region, credentials, tags)
#   variables.tf  -> inputs you can change without editing resources
#   main.tf       -> the resources themselves
#   outputs.tf    -> values printed after apply, or read by other stacks
# ----------------------------------------------------------------------------

terraform {
  # Minimum Terraform version. 1.10 added S3 native state locking (use_lockfile),
  # which the other stacks rely on.
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      # Official AWS provider, published by HashiCorp.
      source = "hashicorp/aws"

      # "~> 6.0" means any 6.x release, but not 7.0. Minor and patch updates are
      # safe; a major version can change resource behaviour, so it needs a review.
      version = "~> 6.0"
    }
  }

  # Backend: where this stack's state lives.
  # Simple version: the bucket is the shared notebook. This stack now keeps its
  # page inside the same bucket it created, instead of on a laptop.
  # Chicken-and-egg note: the bucket already exists, so this is safe to move into.
  backend "s3" {
    bucket       = "us-staffing-tfstate-061624868468-ap-south-1"
    key          = "bootstrap/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true # S3 native locking (current approach)
  }
}
