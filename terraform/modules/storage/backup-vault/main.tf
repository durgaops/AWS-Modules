locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/backup-vault"
    Name      = var.name
  })
}

resource "aws_backup_vault" "this" {
  name          = var.name
  kms_key_arn   = var.kms_key_arn
  force_destroy = var.force_destroy
  tags          = local.tags
}

resource "aws_backup_vault_lock_configuration" "this" {
  count               = var.lock_configuration != null ? 1 : 0
  backup_vault_name   = aws_backup_vault.this.name
  min_retention_days  = var.lock_configuration.min_retention_days
  max_retention_days  = var.lock_configuration.max_retention_days
  changeable_for_days = var.lock_configuration.changeable_for_days
}

resource "aws_backup_vault_policy" "this" {
  count             = var.access_policy != null ? 1 : 0
  backup_vault_name = aws_backup_vault.this.name
  policy            = var.access_policy
}
