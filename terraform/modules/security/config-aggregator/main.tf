# Multi-account Config aggregator.

resource "aws_config_configuration_aggregator" "this" {
  name = var.name

  dynamic "account_aggregation_source" {
    for_each = var.aggregation_type == "ACCOUNT" ? [1] : []
    content {
      account_ids = var.account_ids
      all_regions = var.all_regions
      regions     = var.all_regions ? null : var.regions
    }
  }

  dynamic "organization_aggregation_source" {
    for_each = var.aggregation_type == "ORGANIZATION" ? [1] : []
    content {
      all_regions = var.all_regions
      regions     = var.all_regions ? null : var.regions
      role_arn    = var.organization_aggregator_role_arn
    }
  }

  tags = merge(var.tags, {
    Name      = var.name
    ManagedBy = "terraform"
    Module    = "security/config-aggregator"
  })
}
