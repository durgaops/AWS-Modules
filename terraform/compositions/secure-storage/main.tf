# Platform Composition: secure-storage
# Wires: KMS + S3 primitives

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
  source = "../../modules/kms"

  name        = var.kms_key_name
  description = var.kms_description
  tags        = var.tags
}

module "s3" {
  source = "../../modules/s3"

  bucket_name        = var.bucket_name
  kms_key_arn        = module.kms.key_arn
  versioning_enabled = var.versioning_enabled
  force_destroy      = var.force_destroy
  tags               = var.tags
}
