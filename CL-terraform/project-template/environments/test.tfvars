aws_region    = "us-east-1"
name_prefix   = "app-test"
vpc_cidr      = "10.20.0.0/16"
ami_id        = "ami-REPLACE"
instance_type = "t3.large"
app_bucket_name = "app-test-artifacts-REPLACE"

public_subnets = [
  { cidr_block = "10.20.0.0/24", az = "us-east-1a" },
  { cidr_block = "10.20.1.0/24", az = "us-east-1b" },
]

private_subnets = [
  { cidr_block = "10.20.10.0/24", az = "us-east-1a" },
  { cidr_block = "10.20.11.0/24", az = "us-east-1b" },
]

tags = {
  Project     = "app"
  Environment = "test"
  ManagedBy   = "terraform"
}
