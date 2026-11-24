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

  # No backend block here on purpose. This stack keeps its own state locally,
  # because it creates the bucket that holds every other stack's state.
  # Every later stack will have a backend "s3" block pointing at that bucket.
}
