# Compatibility shim — prefer modules/storage/s3-bucket

module "this" {
  source = "../storage/s3-bucket"

  bucket_name            = var.bucket_name
  force_destroy          = var.force_destroy
  versioning_enabled     = var.versioning_enabled
  require_versioning     = var.versioning_enabled
  kms_key_arn            = var.kms_key_arn
  require_kms            = var.kms_key_arn != null
  allow_sse_s3           = var.kms_key_arn == null
  require_access_logging = false
  required_tag_keys      = []
  name_regex             = ".+"
  lifecycle_rules = [
    for r in var.lifecycle_rules : {
      id              = r.id
      enabled         = r.enabled
      expiration_days = try(r.expiration_days, null)
      transitions     = try(r.transitions, [])
    }
  ]
  tags = var.tags
}
