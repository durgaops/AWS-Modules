# Environment: TEST — values only, no resources

name_prefix = "demo-test"
vpc_cidr    = "10.20.0.0/16"
azs         = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs  = ["10.20.0.0/24", "10.20.1.0/24"]
private_subnet_cidrs = ["10.20.10.0/24", "10.20.11.0/24"]

enable_nat_gateway = true
single_nat_gateway = true

app_bucket_name = "demo-test-app-artifacts-CHANGE-ME"
ami_id          = "ami-CHANGE-ME"
instance_type   = "t3.medium"

db_engine         = "postgres"
db_engine_version = "15"
db_instance_class = "db.t3.medium"
db_name           = "appdb"
db_username       = "appadmin"
db_multi_az            = false
db_deletion_protection = true
db_skip_final_snapshot = false

tags = {
  Environment = "test"
  ManagedBy   = "terraform"
  Owner       = "cloud-coe"
}
