# Compatibility shim — prefer modules/security/kms-key

module "this" {
  source = "../security/kms-key"

  name                    = var.name
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  key_policy              = var.key_policy
  tags                    = var.tags
}
