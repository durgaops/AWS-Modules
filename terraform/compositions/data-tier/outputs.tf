output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_instance_arn" {
  value = module.rds.db_instance_arn
}

output "kms_key_arn" {
  value = module.kms.key_arn
}
