# ----------------------------------------------------------------------------
# variables.tf
#
# Inputs for the OIDC stack. The defaults match the current setup.
#
# Simple version: a trust list says which GitHub repos and branches are allowed
# to ask AWS for a role. Anything not on the list is refused.
# ----------------------------------------------------------------------------

variable "region" {
  description = "AWS region for the IAM resources (IAM itself is global, but the provider needs a region)."
  type        = string
  default     = "ap-south-1"
}

variable "github_org" {
  description = "GitHub organisation that owns the repos. Only repos in this org can use the roles."
  type        = string
  default     = "project-cards"
}

variable "app_repos" {
  description = "App repos allowed to use the roles, for example to push images to ECR."
  type        = list(string)
  default     = ["us-staffing-multitenant-api", "us-staffing-multitenant-ui"]
}

variable "infra_repo" {
  description = "The repo that holds this Terraform code. Its pipeline runs plan and apply."
  type        = string
  default     = "us-staffing-infra"
}

variable "dev_branch" {
  description = "Branch whose pipeline runs may use the dev role."
  type        = string
  default     = "develop"
}

variable "prod_branch" {
  description = "Branch whose pipeline runs may use the prod role."
  type        = string
  default     = "main"
}
