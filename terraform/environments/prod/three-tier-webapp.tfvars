# Environment: PROD — values only, no resources

name_prefix = "demo-prod"
vpc_cidr    = "10.30.0.0/16"
azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_subnet_cidrs  = ["10.30.0.0/24", "10.30.1.0/24", "10.30.2.0/24"]
private_subnet_cidrs = ["10.30.10.0/24", "10.30.11.0/24", "10.30.12.0/24"]

enable_nat_gateway = true
single_nat_gateway = false

app_bucket_name = "demo-prod-app-artifacts-CHANGE-ME"
ami_id          = "ami-CHANGE-ME"
instance_type   = "t3.large"

db_engine         = "postgres"
db_engine_version = "15"
db_instance_class = "db.r6g.large"
db_name           = "appdb"
db_username       = "appadmin"
db_multi_az            = true
db_deletion_protection = true
db_skip_final_snapshot = false

tags = {
  Environment = "prod"
  ManagedBy   = "terraform"
  Owner       = "cloud-coe"
}
