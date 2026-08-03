# Amazon Managed Grafana workspace.

resource "aws_grafana_workspace" "this" {
  name                     = var.name
  account_access_type      = var.account_access_type
  authentication_providers = var.authentication_providers
  permission_type          = var.permission_type
  role_arn                 = var.role_arn
  data_sources             = var.data_sources
  notification_destinations = var.notification_destinations
  grafana_version          = var.grafana_version

  dynamic "vpc_configuration" {
    for_each = var.vpc_configuration != null ? [var.vpc_configuration] : []
    content {
      security_group_ids = vpc_configuration.value.security_group_ids
      subnet_ids         = vpc_configuration.value.subnet_ids
    }
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "observability/managed-grafana"
  })
}

resource "aws_grafana_role_association" "this" {
  for_each = { for a in var.role_associations : "${a.role}:${join(",", a.group_ids)}" => a }

  role         = each.value.role
  group_ids    = try(each.value.group_ids, null)
  user_ids     = try(each.value.user_ids, null)
  workspace_id = aws_grafana_workspace.this.id
}
