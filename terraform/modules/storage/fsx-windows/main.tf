locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/fsx-windows"
    Name      = var.name
  })
}

resource "aws_fsx_windows_file_system" "this" {
  storage_capacity                = var.storage_capacity
  subnet_ids                      = var.subnet_ids
  security_group_ids              = var.security_group_ids
  throughput_capacity             = var.throughput_capacity
  deployment_type                 = var.deployment_type
  preferred_subnet_id             = var.preferred_subnet_id
  active_directory_id             = var.active_directory_id
  kms_key_id                      = var.kms_key_id
  automatic_backup_retention_days = var.automatic_backup_retention_days
  copy_tags_to_backups            = var.copy_tags_to_backups
  tags                            = local.tags
}
