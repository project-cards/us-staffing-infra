# ----------------------------------------------------------------------------
# ecr-push.tf
#
# A role for the two APP repos (API and UI). Their pipelines use it to log in to
# ECR and push images, and nothing else.
#
# Simple picture: a delivery pass. It opens the loading bay (ECR) and nothing else.
# It is NOT the dev admin role: an app pipeline gets only the access it needs.
#
# The trust list uses the numeric IDs of the org and each repo, because the
# organisation's "immutable subject" setting puts those numbers in every badge.
# ----------------------------------------------------------------------------

locals {
  # Numeric IDs of the two app repos (look them up with: gh api repos/<org>/<repo> --jq .id)
  api_repo_id = "1469725149"
  ui_repo_id  = "1469725201"

  # Prefix of each app repo's badge, for example:
  #   repo:project-cards@306973792/us-staffing-multitenant-api@1469725149
  api_subject_prefix = "repo:${var.github_org}@${var.github_org_id}/us-staffing-multitenant-api@${local.api_repo_id}"
  ui_subject_prefix  = "repo:${var.github_org}@${var.github_org_id}/us-staffing-multitenant-ui@${local.ui_repo_id}"

  # Only pushes from these branches can use the role: develop (dev) and main (prod).
  ecr_push_subjects = flatten([
    for p in [local.api_subject_prefix, local.ui_subject_prefix] : [
      "${p}:ref:refs/heads/${var.dev_branch}",
      "${p}:ref:refs/heads/${var.prod_branch}",
    ]
  ])
}

data "aws_iam_policy_document" "ecr_push_trust" {
  statement {
    sid     = "AppReposOnDevAndMain"
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
      values   = local.ecr_push_subjects
    }
  }
}

resource "aws_iam_role" "ecr_push" {
  name                 = "us-staffing-app-ecr-push"
  description          = "Used by the API and UI pipelines to push images to ECR. Nothing else."
  assume_role_policy   = data.aws_iam_policy_document.ecr_push_trust.json
  max_session_duration = 3600
}

# Only what a push needs: log in to ECR, and push to the app repos.
# The repo names follow the us-staffing-* pattern, so this covers the API and UI repos.
data "aws_iam_policy_document" "ecr_push_permissions" {
  statement {
    sid       = "EcrLogin"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "PushAppImages"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
    ]
    resources = ["arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/us-staffing-*"]
  }
}

resource "aws_iam_role_policy" "ecr_push" {
  name   = "ecr-push-only"
  role   = aws_iam_role.ecr_push.id
  policy = data.aws_iam_policy_document.ecr_push_permissions.json
}

output "ecr_push_role_arn" {
  description = "Store this as the repo variable AWS_ROLE_ARN_ECR_PUSH in both app repos."
  value       = aws_iam_role.ecr_push.arn
}
