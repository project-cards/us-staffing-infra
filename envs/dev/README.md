# Dev environment

Settings and state for the development environment (account 061624868468, region ap-south-1).

## State keys (one per stack)

| Stack | State key in the bucket |
|---|---|
| network | `dev/network/terraform.tfstate` |
| ecr | `dev/ecr/terraform.tfstate` |
| eks | `dev/eks/terraform.tfstate` |
| data | `dev/data/terraform.tfstate` |
| apps-config | `dev/apps-config/terraform.tfstate` |

Bucket: `us-staffing-tfstate-061624868468-ap-south-1`

## Dev values (planned)

- VPC range: `10.10.0.0/16`
- Zones: two
- NAT gateways: one
- Node OS: Bottlerocket
- Nodes: 2 to start, with room to scale
- Interface endpoints: none for now

No secrets in this folder.
