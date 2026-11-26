# ----------------------------------------------------------------------------
# main.tf (shared / ecr)
#
# The shared values for the image repositories. The logic lives in modules/ecr.
# The KMS key ARN is the one from the bootstrap stack.
# ----------------------------------------------------------------------------

module "ecr" {
  source = "../../../modules/ecr"

  repo_names  = ["us-staffing-api", "us-staffing-ui"]
  kms_key_arn = "arn:aws:kms:ap-south-1:061624868468:key/926007ab-1855-49fa-ac56-65f283b59d38"

  tags = {
    project = "us-staffing"
    owner   = "pavan"
  }
}
