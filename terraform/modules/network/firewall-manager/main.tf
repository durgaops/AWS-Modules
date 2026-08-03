# Central Firewall Manager policy management (org-level).

resource "aws_fms_policy" "this" {
  name                  = var.name
  exclude_resource_tags = var.exclude_resource_tags
  remediation_enabled   = var.remediation_enabled
  resource_type         = var.resource_type
  resource_type_list    = var.resource_type_list

  security_service_policy_data {
    type                 = var.security_service_type
    managed_service_data = var.managed_service_data
  }

  dynamic "include_map" {
    for_each = length(var.include_account_ids) > 0 || length(var.include_org_units) > 0 ? [1] : []
    content {
      account = var.include_account_ids
      orgunit = var.include_org_units
    }
  }

  dynamic "exclude_map" {
    for_each = length(var.exclude_account_ids) > 0 || length(var.exclude_org_units) > 0 ? [1] : []
    content {
      account = var.exclude_account_ids
      orgunit = var.exclude_org_units
    }
  }

  tags = merge(var.tags, { Name = var.name })
}
