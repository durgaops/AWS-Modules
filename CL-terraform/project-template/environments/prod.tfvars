aws_region    = "us-east-1"
name_prefix   = "app-prod"
vpc_cidr      = "10.30.0.0/16"
ami_id        = "ami-REPLACE"
instance_type = "m5.large"
app_bucket_name = "app-prod-artifacts-REPLACE"

public_subnets = [
  { cidr_block = "10.30.0.0/24", az = "us-east-1a" },
  { cidr_block = "10.30.1.0/24", az = "us-east-1b" },
]

private_subnets = [
  { cidr_block = "10.30.10.0/24", az = "us-east-1a" },
  { cidr_block = "10.30.11.0/24", az = "us-east-1b" },
]

tags = {
  Project     = "app"
  Environment = "prod"
  ManagedBy   = "terraform"
}
