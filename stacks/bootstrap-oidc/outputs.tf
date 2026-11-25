# ----------------------------------------------------------------------------
# outputs.tf
#
# The role ARNs are printed after apply. ARN = the full name of an AWS resource.
# These are NOT secrets (they hold no passwords), so they can be stored as GitHub
# repository variables. The pipeline reads them and asks AWS for a role.
# ----------------------------------------------------------------------------

output "dev_role_arn" {
  description = "Put this in GitHub as the repo variable AWS_ROLE_ARN_DEV."
  value       = aws_iam_role.dev.arn
}

output "prod_role_arn" {
  description = "Put this in GitHub as the repo variable AWS_ROLE_ARN_PROD (used only by the prod Environment)."
  value       = aws_iam_role.prod.arn
}

output "plan_role_arn" {
  description = "Put this in GitHub as the repo variable AWS_ROLE_ARN_PLAN (used by pull request plans)."
  value       = aws_iam_role.plan.arn
}

output "oidc_provider_arn" {
  description = "The GitHub identity provider registered in AWS."
  value       = aws_iam_openid_connect_provider.github.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
