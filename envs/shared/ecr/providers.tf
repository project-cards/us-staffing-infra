# ----------------------------------------------------------------------------
# providers.tf (shared / ecr)
# ----------------------------------------------------------------------------

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      project     = "us-staffing"
      environment = "shared"
      owner       = "pavan"
      managed_by  = "terraform"
      stack       = "ecr"
    }
  }
}
