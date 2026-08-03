output "kms_key_arn" {
  value = module.kms.key_arn
}

output "bucket_id" {
  value = module.s3.bucket_id
}

output "bucket_arn" {
  value = module.s3.bucket_arn
}
