# Prod environment

Not built yet. We create it after dev is working.

Planned values, to be confirmed:
- VPC range: `10.20.0.0/16`
- Zones: three
- NAT gateways: one per zone

State keys will follow the same pattern as dev: `prod/<stack>/terraform.tfstate`.
