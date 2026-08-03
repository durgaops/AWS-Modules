# Compatibility shim — prefer modules/identity/iam-role

module "this" {
  source = "../identity/iam-role"

  name                    = var.name
  assume_role_policy      = var.assume_role_policy
  managed_policy_arns     = var.managed_policy_arns
  inline_policies         = var.inline_policies
  max_session_duration    = var.max_session_duration
  permissions_boundary_arn = var.permissions_boundary_arn
  create_instance_profile = var.create_instance_profile
  name_regex              = "^[a-zA-Z0-9+=,.@_-]+$"
  required_tag_keys       = []
  allow_inline_policies   = length(var.inline_policies) > 0
  max_inline_policies     = max(length(var.inline_policies), 2)
  tags                    = var.tags
}
