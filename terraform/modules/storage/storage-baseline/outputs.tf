output "bucket_id" { value = module.bucket.bucket_id }
output "bucket_arn" { value = module.bucket.bucket_arn }
output "access_point_arns" { value = module.bucket.access_point_arns }
output "backup_vault_arn" { value = try(module.backup_vault[0].vault_arn, null) }
