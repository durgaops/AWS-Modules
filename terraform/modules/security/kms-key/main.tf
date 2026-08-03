# Standard customer-managed KMS key with rotation, alias, and key policy hooks.

resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  multi_region            = false
  policy                  = var.key_policy
  is_enabled              = var.is_enabled
  key_usage               = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "security/kms-key"
  })
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  count  = var.key_policy != null && var.manage_key_policy_resource ? 1 : 0
  key_id = aws_kms_key.this.id
  policy = var.key_policy
}
