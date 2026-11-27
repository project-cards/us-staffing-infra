# ----------------------------------------------------------------------------
# providers.tf (dev / data)
# ----------------------------------------------------------------------------

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      project     = "us-staffing"
      environment = "dev"
      owner       = "pavan"
      managed_by  = "terraform"
      stack       = "data"
    }
  }
}
