# us-staffing-infra

Terraform code for the US Staffing platform on AWS (account `061624868468`, region `ap-south-1`).

## Layout

- `stacks/bootstrap/`      State bucket and KMS key. Applied once from a laptop.
- `stacks/bootstrap-oidc/` GitHub OIDC provider and the dev/prod pipeline roles. Applied once from a laptop.
- Later stacks (network, EKS, data, apps) will be added here and applied by the pipeline.

## Rules

1. Never commit state files (`*.tfstate*`) or `terraform.tfvars` with values.
2. Changes go through a pull request. `plan` is shown on the PR; `apply` runs after merge.
3. The bootstrap stacks are applied by hand only, because the pipeline depends on them.
