locals {
  missing_required_tags = [for k in var.required_tag_keys : k if !contains(keys(var.tags), k)]
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/s3-static-site"
    Name      = var.bucket_name
  })
}

resource "terraform_data" "guardrails" {
  lifecycle {
    precondition {
      condition     = length(local.missing_required_tags) == 0
      error_message = "Missing required tags: ${join(", ", local.missing_required_tags)}"
    }
  }
}

resource "aws_s3_bucket" "this" {
  bucket     = var.bucket_name
  tags       = local.tags
  depends_on = [terraform_data.guardrails]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule { object_ownership = "BucketOwnerEnforced" }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = var.kms_key_arn != null
  }
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  index_document { suffix = var.index_document }
  error_document { key = var.error_document }
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.logging != null ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.logging.target_bucket
  target_prefix = var.logging.target_prefix
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "DenyInsecureTransport"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]
    principals { type = "*" identifiers = ["*"] }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid       = "AllowCloudFrontRead"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [var.cloudfront_oai_iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket     = aws_s3_bucket.this.id
  policy     = data.aws_iam_policy_document.this.json
  depends_on = [aws_s3_bucket_public_access_block.this]
}
