# CloudWatch Application Insights baseline.

resource "aws_applicationinsights_application" "this" {
  resource_group_name = var.resource_group_name
  auto_config_enabled = var.auto_config_enabled
  auto_create         = var.auto_create
  cwe_monitor_enabled = var.cwe_monitor_enabled
  ops_center_enabled  = var.ops_center_enabled
  ops_item_sns_topic_arn = var.ops_item_sns_topic_arn
  grouping_type       = var.grouping_type

  tags = merge(var.tags, {
    Name   = var.resource_group_name
    Module = "observability/application-insights"
  })
}

resource "aws_resourcegroups_group" "this" {
  count = var.create_resource_group ? 1 : 0
  name  = var.resource_group_name

  resource_query {
    query = var.resource_group_query
  }

  tags = var.tags
}
