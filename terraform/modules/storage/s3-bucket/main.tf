################################################################################
# Enterprise S3 bucket baseline with Cloud COE guardrails:
# - Block Public Access (always)
# - Encryption (KMS required by default)
# - Ownership controls (BucketOwnerEnforced)
# - Versioning
# - Access logging
# - Lifecycle support
# - Required tags
# - Policy validation (TLS / unencrypted uploads / public deny)
# - Optional replication
# - Optional Object Lock
# - Access-point governance
################################################################################

locals {
  required_tag_keys = toset(var.required_tag_keys)

  missing_required_tags = [
    for k in local.required_tag_keys : k if !contains(keys(var.tags), k)
  ]

  access_points_missing_vpc = [
    for k, ap in var.access_points : k if ap.vpc_id == null
  ]

  sse_algorithm = var.kms_key_arn != null ? "aws:kms" : "AES256"

  ownership_tags = merge(
    {
      ManagedBy = "terraform"
      Module    = "storage/s3-bucket"
    },
    var.owner != null ? { Owner = var.owner } : {},
    var.cost_center != null ? { CostCenter = var.cost_center } : {},
    var.data_classification != null ? { DataClassification = var.data_classification } : {}
  )

  tags = merge(local.ownership_tags, var.tags, { Name = var.bucket_name })

  enable_lifecycle   = length(var.lifecycle_rules) > 0
  enable_replication = var.replication != null
}

resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = can(regex(var.name_regex, var.bucket_name))
      error_message = "Bucket name '${var.bucket_name}' does not match required pattern: ${var.name_regex}"
    }

    precondition {
      condition     = length(local.missing_required_tags) == 0
      error_message = "Missing required tags: ${join(", ", local.missing_required_tags)}"
    }

    precondition {
      condition     = !var.require_kms || var.kms_key_arn != null
      error_message = "kms_key_arn is required (require_kms=true)."
    }

    precondition {
      condition     = var.kms_key_arn != null || var.allow_sse_s3
      error_message = "Either provide kms_key_arn or set allow_sse_s3=true."
    }

    precondition {
      condition     = !var.require_versioning || var.versioning_enabled
      error_message = "versioning_enabled must be true (require_versioning=true)."
    }

    precondition {
      condition     = !var.require_access_logging || var.logging != null
      error_message = "logging.target_bucket is required (require_access_logging=true)."
    }

    precondition {
      condition     = !var.enable_object_lock || var.versioning_enabled
      error_message = "Object Lock requires versioning_enabled=true."
    }

    precondition {
      condition     = contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_configuration.mode)
      error_message = "object_lock_configuration.mode must be GOVERNANCE or COMPLIANCE."
    }

    precondition {
      condition     = !var.require_vpc_access_points || length(local.access_points_missing_vpc) == 0
      error_message = "Access point(s) must be VPC-restricted: ${join(", ", local.access_points_missing_vpc)}"
    }

    precondition {
      condition     = !var.force_destroy || try(lower(var.tags["Environment"]), "") != "prod"
      error_message = "force_destroy=true is not allowed when Environment tag is prod."
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket              = var.bucket_name
  force_destroy       = var.force_destroy
  object_lock_enabled = var.enable_object_lock
  tags                = local.tags

  depends_on = [terraform_data.guardrails]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = local.sse_algorithm
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = var.kms_key_arn != null ? var.bucket_key_enabled : false
  }
}

resource "aws_s3_bucket_logging" "this" {
  count = var.logging != null ? 1 : 0

  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = local.enable_lifecycle ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      filter {
        prefix = coalesce(rule.value.prefix, "")
      }

      dynamic "expiration" {
        for_each = rule.value.expiration_days != null ? [rule.value.expiration_days] : []
        content {
          days = expiration.value
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration_days != null ? [rule.value.noncurrent_version_expiration_days] : []
        content {
          noncurrent_days = noncurrent_version_expiration.value
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_days != null ? [rule.value.abort_incomplete_multipart_days] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value
        }
      }

      dynamic "transition" {
        for_each = rule.value.transitions
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions
        content {
          noncurrent_days = noncurrent_version_transition.value.noncurrent_days
          storage_class   = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count  = var.enable_object_lock ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    default_retention {
      mode = var.object_lock_configuration.mode
      days = var.object_lock_configuration.days
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "terraform_data" "policy_validation" {
  count = var.bucket_policy != null ? 1 : 0

  lifecycle {
    precondition {
      condition     = !var.deny_insecure_transport || can(regex("(?i)aws:SecureTransport", var.bucket_policy))
      error_message = "Custom bucket_policy must include aws:SecureTransport deny when deny_insecure_transport=true."
    }

    precondition {
      condition     = !can(regex("(?i)\"Effect\"\\s*:\\s*\"Allow\"[\\s\\S]*\"Principal\"\\s*:\\s*\"\\*\"", var.bucket_policy))
      error_message = "Custom bucket_policy appears to Allow Principal '*' (public). Remove public Allow statements."
    }
  }
}

# Default validated policy. Used unless caller supplies bucket_policy.
data "aws_iam_policy_document" "guarded" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  dynamic "statement" {
    for_each = var.deny_unencrypted_uploads ? [1] : []
    content {
      sid       = "DenyUnencryptedObjectUploads"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.this.arn}/*"]
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      condition {
        test     = "Null"
        variable = "s3:x-amz-server-side-encryption"
        values   = ["true"]
      }
    }
  }

  statement {
    sid     = "DenyPublicAclAndPolicyBypass"
    effect  = "Deny"
    actions = [
      "s3:PutBucketPublicAccessBlock",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketAcl",
      "s3:PutObjectAcl"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalTag/BreakGlass"
      values   = ["true"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy != null ? var.bucket_policy : data.aws_iam_policy_document.guarded.json

  depends_on = [
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket_ownership_controls.this,
    terraform_data.policy_validation
  ]
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count  = local.enable_replication ? 1 : 0
  bucket = aws_s3_bucket.this.id
  role   = var.replication.role_arn

  rule {
    id     = "enterprise-replication"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = var.replication.destination_bucket_arn
      storage_class = var.replication.storage_class

      dynamic "encryption_configuration" {
        for_each = coalesce(var.replication.destination_kms_key_arn, var.replication.replica_kms_key_id) != null ? [1] : []
        content {
          replica_kms_key_id = coalesce(var.replication.destination_kms_key_arn, var.replication.replica_kms_key_id)
        }
      }

      dynamic "replication_time" {
        for_each = var.replication.metrics_enabled ? [1] : []
        content {
          status = "Enabled"
          time {
            minutes = var.replication.replication_time_minutes
          }
        }
      }

      dynamic "metrics" {
        for_each = var.replication.metrics_enabled ? [1] : []
        content {
          status = "Enabled"
          event_threshold {
            minutes = var.replication.replication_time_minutes
          }
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.this]
}

resource "aws_s3_access_point" "this" {
  for_each = var.access_points

  name   = each.value.name
  bucket = aws_s3_bucket.this.id

  dynamic "vpc_configuration" {
    for_each = each.value.vpc_id != null ? [each.value.vpc_id] : []
    content {
      vpc_id = vpc_configuration.value
    }
  }

  public_access_block_configuration {
    block_public_acls       = each.value.public_access_block.block_public_acls
    block_public_policy     = each.value.public_access_block.block_public_policy
    ignore_public_acls      = each.value.public_access_block.ignore_public_acls
    restrict_public_buckets = each.value.public_access_block.restrict_public_buckets
  }

  tags = local.tags
}

resource "aws_s3control_access_point_policy" "this" {
  for_each = {
    for k, ap in var.access_points : k => ap if ap.policy != null
  }

  access_point_arn = aws_s3_access_point.this[each.key].arn
  policy           = each.value.policy
}
