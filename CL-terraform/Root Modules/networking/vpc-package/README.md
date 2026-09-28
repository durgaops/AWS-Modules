# networking/vpc-package

One reusable module that deploys the standard VPC foundation together:

| Included | Default |
|----------|---------|
| VPC (DNS on) | Always |
| Public / private / database subnets | Whatever you pass |
| Internet Gateway | If public subnets exist |
| NAT Gateway | On, one shared NAT, if public + private exist |
| Route tables | Public → IGW, private → NAT, database → no internet |
| Network ACLs | Public 80/443, private VPC + return traffic, database DB ports |
| Default security group | Restrict (remove allow-all) |
| VPC Flow Logs | On (you must pass the destination ARN) |
| S3 + DynamoDB gateway endpoints | On |
| SSM / SSM Messages / EC2 Messages interface endpoints | On (for patching inside this VPC) |

ALB, NLB, Transit Gateway attachment, and Route 53 stay separate. Call those only when the application needs them.

## Example

```hcl
module "network" {
  source = "git::https://github.com/<org>/<repo>.git//CL-terraform/Root%20Modules/networking/vpc-package?ref=v1.0.0"

  name       = "payments-dev"
  cidr_block = "10.10.0.0/16"

  public_subnets = [
    { cidr_block = "10.10.0.0/24", az = "us-east-1a" },
    { cidr_block = "10.10.1.0/24", az = "us-east-1b" },
  ]

  private_subnets = [
    { cidr_block = "10.10.10.0/24", az = "us-east-1a" },
    { cidr_block = "10.10.11.0/24", az = "us-east-1b" },
  ]

  database_subnets = [
    { cidr_block = "10.10.20.0/24", az = "us-east-1a" },
    { cidr_block = "10.10.21.0/24", az = "us-east-1b" },
  ]

  flow_log_destination_arn = "arn:aws:s3:::central-vpc-flow-logs"
  tags = {
    Project     = "payments"
    Environment = "dev"
  }
}
```
