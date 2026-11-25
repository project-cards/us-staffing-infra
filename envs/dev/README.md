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

## Dev subnets (checked: no overlaps)

| Subnet | Range | Addresses |
|---|---|---|
| Public, zone A | `10.10.0.0/24` | 256 |
| Public, zone B | `10.10.1.0/24` | 256 |
| App, zone A | `10.10.4.0/22` | 1,024 |
| App, zone B | `10.10.8.0/22` | 1,024 |
| Database, zone A | `10.10.20.0/24` | 256 |
| Database, zone B | `10.10.21.0/24` | 256 |

No secrets in this folder.
