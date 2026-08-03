# Encryption, retention and public-access protections baseline (account-level).

resource "aws_s3_account_public_access_block" "this" {
  count = var.enable_s3_account_public_access_block ? 1 : 0

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_ebs_encryption_by_default" "this" {
  count   = var.enable_ebs_encryption_by_default ? 1 : 0
  enabled = true
}

resource "aws_ebs_default_kms_key" "this" {
  count   = var.ebs_default_kms_key_arn != null ? 1 : 0
  key_arn = var.ebs_default_kms_key_arn
}

resource "aws_ec2_instance_metadata_defaults" "this" {
  count = var.enforce_imdsv2 ? 1 : 0

  http_tokens                 = "required"
  http_put_response_hop_limit = var.imds_hop_limit
  http_endpoint               = "enabled"
  instance_metadata_tags      = var.instance_metadata_tags
}

resource "aws_ec2_image_block_public_access" "this" {
  count = var.block_public_amis ? 1 : 0
  state = "block-new-sharing"
}
