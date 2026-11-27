# ----------------------------------------------------------------------------
# main.tf (dev / data)
#
# The dev database. Nothing is typed in by hand: the subnets come from the network
# stack, and the cluster security group comes from the EKS stack.
# ----------------------------------------------------------------------------

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "us-staffing-tfstate-061624868468-ap-south-1"
    key    = "dev/network/terraform.tfstate"
    region = "ap-south-1"
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "us-staffing-tfstate-061624868468-ap-south-1"
    key    = "dev/eks/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "data" {
  source = "../../../modules/data"

  name                      = "us-staffing-dev"
  vpc_id                    = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids                = data.terraform_remote_state.network.outputs.db_subnet_ids
  cluster_security_group_id = data.terraform_remote_state.eks.outputs.cluster_security_group_id
  kms_key_arn               = "arn:aws:kms:ap-south-1:061624868468:key/926007ab-1855-49fa-ac56-65f283b59d38"

  # Dev choices: one zone, small size, no deletion protection, no final snapshot.
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  multi_az              = false
  backup_retention_days = 7
  deletion_protection   = false
  skip_final_snapshot   = true

  tags = {
    project = "us-staffing"
    owner   = "pavan"
  }
}
