module "bucket" {
  source = "../s3-bucket"

  bucket_name               = var.bucket_name
  kms_key_arn               = var.kms_key_arn
  require_kms               = true
  require_versioning        = true
  require_access_logging    = true
  enable_object_lock        = var.enable_object_lock
  lifecycle_rules           = var.lifecycle_rules
  access_points             = var.access_points
  require_vpc_access_points = true
  logging = {
    target_bucket = var.logging_bucket_id
    target_prefix = var.logging_prefix
  }
  tags = var.tags
}

module "backup_vault" {
  source = "../backup-vault"
  count  = var.create_backup_vault ? 1 : 0

  name        = coalesce(var.backup_vault_name, "${var.bucket_name}-vault")
  kms_key_arn = var.kms_key_arn
  tags        = var.tags
}
