# ----------------------------------------------------------------------------
# main.tf (dev / eks)
#
# The dev cluster. The subnets come from the dev network stack's state, so nothing
# is typed in by hand. The KMS key comes from the bootstrap stack.
# ----------------------------------------------------------------------------

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "us-staffing-tfstate-061624868468-ap-south-1"
    key    = "dev/network/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "eks" {
  source = "../../../modules/eks"

  name               = "us-staffing-dev"
  kubernetes_version = "1.34"

  subnet_ids  = data.terraform_remote_state.network.outputs.app_subnet_ids
  kms_key_arn = "arn:aws:kms:ap-south-1:061624868468:key/926007ab-1855-49fa-ac56-65f283b59d38"

  # Who may use the cluster: the dev pipeline role, and your practice user.
  admin_principal_arns = [
    "arn:aws:iam::061624868468:role/us-staffing-github-dev",
    "arn:aws:iam::061624868468:user/practice-admin",
    "arn:aws:iam::061624868468:user/pavan",
  ]

  node_instance_types = ["t3.medium"]
  node_min_size       = 2
  node_desired_size   = 2
  node_max_size       = 4

  tags = {
    project = "us-staffing"
    owner   = "pavan"
  }
}
