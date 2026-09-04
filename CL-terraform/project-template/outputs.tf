output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
}

output "internet_gateway_id" {
  value = module.internet_gateway.internet_gateway_id
}

output "nat_gateway_ids" {
  value = module.nat_gateway.nat_gateway_ids
}

output "route_table_ids" {
  value = module.route_tables.route_table_ids
}

output "app_instance_id" {
  value = module.app_ec2.instance_id
}

output "app_bucket_id" {
  value = module.app_bucket.bucket_id
}

output "kms_key_arn" {
  value = module.app_kms.key_arn
}
