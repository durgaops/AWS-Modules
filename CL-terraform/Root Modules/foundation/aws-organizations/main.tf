# Reusable AWS Organizations foundation (OUs + optional feature toggles).
# Apply from management account only. No environment hardcoding.

resource "aws_organizations_organization" "this" {
  count = var.create_organization ? 1 : 0

  aws_service_access_principals = var.aws_service_access_principals
  enabled_policy_types          = var.enabled_policy_types
  feature_set                   = var.feature_set
}

locals {
  root_id = var.create_organization ? aws_organizations_organization.this[0].roots[0].id : var.root_id
}

resource "aws_organizations_organizational_unit" "this" {
  for_each = var.organizational_units

  name      = each.key
  parent_id = coalesce(try(each.value.parent_id, null), local.root_id)
  tags      = merge(var.tags, try(each.value.tags, {}), { Module = "foundation/aws-organizations" })
}
