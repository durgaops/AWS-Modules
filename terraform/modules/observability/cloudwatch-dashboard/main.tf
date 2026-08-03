# Infrastructure and application CloudWatch dashboards.

resource "aws_cloudwatch_dashboard" "this" {
  for_each = { for d in var.dashboards : d.name => d }

  dashboard_name = each.value.name
  dashboard_body = each.value.body
}
