# ----------------------------------------------------------------------------
# providers.tf
#
# Configures how Terraform talks to AWS: which region, which credentials, and
# which tags are added to every resource automatically.
#
# Credentials are NOT set in this file. Terraform reads them from:
#   - On your laptop:  the profile named in AWS_PROFILE (for example: export AWS_PROFILE=practice)
#   - In GitHub Actions: temporary credentials from OIDC (no keys stored anywhere)
# That way the same code works in both places without editing it.
# ----------------------------------------------------------------------------

provider "aws" {
  # Region where the resources are created.
  region = var.region

  # AWS CLI profile to use. Null means "use the default credential chain",
  # which is what the pipeline needs. On your laptop, set AWS_PROFILE instead.
  profile = var.profile

  # Tags added to every resource this stack creates. Tags make costs and
  # ownership easy to filter in AWS Cost Explorer and in the console.
  default_tags {
    tags = {
      project    = "us-staffing"
      owner      = "pavan"
      managed_by = "terraform"
      stack      = "bootstrap"
    }
  }
}
