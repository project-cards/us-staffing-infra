# ----------------------------------------------------------------------------
# main.tf (dev / network)
#
# The dev values for the network. This file only supplies numbers and names;
# all the logic lives in modules/network, shared with prod.
#
# The ranges (dev, not overlapping prod's 10.20.0.0/16):
#   VPC              10.10.0.0/16
#   public  (2)      10.10.0.0/24, 10.10.1.0/24
#   app     (2)      10.10.4.0/22, 10.10.8.0/22   (room for many pods per zone)
#   database (2)     10.10.20.0/24, 10.10.21.0/24
# ----------------------------------------------------------------------------

module "network" {
  source = "../../../modules/network"

  name   = "us-staffing-dev"
  region = "ap-south-1"

  vpc_cidr = "10.10.0.0/16"
  azs      = ["ap-south-1a", "ap-south-1b"]

  public_subnet_cidrs = ["10.10.0.0/24", "10.10.1.0/24"]
  app_subnet_cidrs    = ["10.10.4.0/22", "10.10.8.0/22"]
  db_subnet_cidrs     = ["10.10.20.0/24", "10.10.21.0/24"]

  # Dev: one NAT to save cost. Prod will set this to false.
  single_nat_gateway = true
}
