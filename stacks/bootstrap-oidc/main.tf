# ----------------------------------------------------------------------------
# main.tf
#
# Creates three things:
#   1. An OIDC provider: tells AWS "trust ID cards issued by GitHub Actions".
#   2. A dev role: what a pipeline run on the develop branch can use.
#   3. A prod role: what a pipeline run on the main branch can use.
#
# Simple example:
#   A run on branch "develop" in repo "project-cards/us-staffing-infra" shows GitHub's ID card.
#   AWS checks the card: is it from GitHub? Is it this repo? Is it this branch?
#   If all three match, AWS gives the run a role for 1 hour. No keys stored anywhere.
# ----------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

# ----------------------------------------------------------------------------
# OIDC PROVIDER
#
# Why: it registers GitHub's token service with AWS. Without it, AWS has no idea
# that GitHub ID cards exist and would refuse every request.
# The URL is GitHub's token issuer. The thumbprint is the fingerprint of its
# certificate (AWS also checks it against a list of trusted CAs).
# ----------------------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}

# ----------------------------------------------------------------------------
# TRUST POLICY (who may use the role), built for each role below.
#
# Simple rule: the "sub" claim in the ID card holds the repo and branch, like
#   repo:project-cards/us-staffing-infra:ref:refs/heads/develop
# We allow only the exact combinations we list. Wildcards would let any branch in
# the repo use the role, so we avoid them.
# ----------------------------------------------------------------------------
locals {
  # Dev role: infra repo on develop, and the app repos on develop (for pushing images).
  dev_subjects = concat(
    ["repo:${var.github_org}/${var.infra_repo}:ref:refs/heads/${var.dev_branch}"],
    [for r in var.app_repos : "repo:${var.github_org}/${r}:ref:refs/heads/${var.dev_branch}"]
  )

  # Prod role: infra repo on main only.
  prod_subjects = ["repo:${var.github_org}/${var.infra_repo}:ref:refs/heads/${var.prod_branch}"]
}

data "aws_iam_policy_document" "dev_trust" {
  statement {
    sid     = "GitHubDevBranchOnly"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    # The audience must be sts.amazonaws.com (the token is meant for AWS STS).
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # The subject must be one of the exact repo and branch pairs listed above.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.dev_subjects
    }
  }
}

data "aws_iam_policy_document" "prod_trust" {
  statement {
    sid     = "GitHubProdMainOnly"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.prod_subjects
    }
  }
}

# ----------------------------------------------------------------------------
# ROLES
#
# A role is a set of permissions that anyone allowed by the trust policy can wear
# for a short time. Unlike a user, a role has no password or access key.
# ----------------------------------------------------------------------------
resource "aws_iam_role" "dev" {
  name               = "us-staffing-github-dev"
  description        = "Used by GitHub Actions on develop to deploy dev infrastructure"
  assume_role_policy = data.aws_iam_policy_document.dev_trust.json

  # Tokens last 1 hour, so a run cannot keep access longer than needed.
  max_session_duration = 3600
}

resource "aws_iam_role" "prod" {
  name               = "us-staffing-github-prod"
  description        = "Used by GitHub Actions on main to deploy prod infrastructure"
  assume_role_policy = data.aws_iam_policy_document.prod_trust.json
  max_session_duration = 3600
}

# ----------------------------------------------------------------------------
# PERMISSIONS
#
# TEMPORARY: AdministratorAccess lets Terraform create everything in this practice
# account (VPC, EKS, RDS, and so on). Real teams start narrow and add permissions as
# needed. We will tighten these roles once the stacks exist, and say so in the guide.
# ----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "dev_admin" {
  role       = aws_iam_role.dev.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "prod_admin" {
  role       = aws_iam_role.prod.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
