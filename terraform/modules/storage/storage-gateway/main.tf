locals {
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "storage/storage-gateway"
    Name      = var.gateway_name
  })
}

resource "aws_storagegateway_gateway" "this" {
  gateway_name     = var.gateway_name
  gateway_timezone = var.gateway_timezone
  gateway_type     = var.gateway_type
  activation_key   = var.activation_key
  tags             = local.tags

  dynamic "smb_active_directory_settings" {
    for_each = var.smb_active_directory_settings != null ? [var.smb_active_directory_settings] : []
    content {
      domain_name = smb_active_directory_settings.value.domain_name
      username    = smb_active_directory_settings.value.username
      password    = smb_active_directory_settings.value.password
    }
  }
}
