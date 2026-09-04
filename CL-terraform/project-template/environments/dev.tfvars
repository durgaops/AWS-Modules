aws_region      = "us-east-1"
name_prefix     = "app-dev"
vpc_cidr        = "10.10.0.0/16"
ami_id          = "ami-REPLACE"
instance_type   = "t3.medium"
app_bucket_name = "app-dev-artifacts-REPLACE"

# Public subnets host the Internet Gateway route path and NAT Gateways
public_subnets = [
  { cidr_block = "10.10.0.0/24", az = "us-east-1a" },
  { cidr_block = "10.10.1.0/24", az = "us-east-1b" },
]

# Private subnets use NAT for egress via route-tables module
private_subnets = [
  { cidr_block = "10.10.10.0/24", az = "us-east-1a" },
  { cidr_block = "10.10.11.0/24", az = "us-east-1b" },
]

tags = {
  Project     = "app"
  Environment = "dev"
  ManagedBy   = "terraform"
}
