# Platform Composition: secure-storage
# Wires: security/kms-key + storage/s3-bucket (+ optional logging target)

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "kms" {
  source = "../../../modules/security/kms-key"

  name        = var.kms_key_name
  description = var.kms_description
  tags        = var.tags
}

module "s3" {
  source = "../../../modules/storage/s3-bucket"

  bucket_name            = var.bucket_name
  kms_key_arn            = module.kms.key_arn
  require_kms            = true
  require_versioning     = var.versioning_enabled
  versioning_enabled     = var.versioning_enabled
  force_destroy          = var.force_destroy
  require_access_logging = var.logging_bucket_id != null
  logging = var.logging_bucket_id != null ? {
    target_bucket = var.logging_bucket_id
    target_prefix = var.logging_prefix
  } : null
  lifecycle_rules = var.lifecycle_rules
  enable_object_lock = var.enable_object_lock
  access_points      = var.access_points
  tags               = var.tags
}
