# ----------------------------------------------------------------------------
# providers.tf (dev / network)
#
# Which region to build in, and the tags added to everything in this stack.
# Credentials are not set here: the laptop uses AWS_PROFILE, and the pipeline
# uses OIDC.
# ----------------------------------------------------------------------------

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      project     = "us-staffing"
      environment = "dev"
      owner       = "pavan"
      managed_by  = "terraform"
      stack       = "network"
    }
  }
}
