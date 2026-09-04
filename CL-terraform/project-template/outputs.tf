output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.subnets.private_subnet_ids
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
