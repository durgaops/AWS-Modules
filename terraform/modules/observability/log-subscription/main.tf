# CloudWatch Logs subscription filters.

resource "aws_cloudwatch_log_subscription_filter" "this" {
  for_each = { for f in var.subscription_filters : f.name => f }

  name            = each.value.name
  log_group_name  = each.value.log_group_name
  filter_pattern  = try(each.value.filter_pattern, "")
  destination_arn = each.value.destination_arn
  role_arn        = try(each.value.role_arn, var.default_role_arn)
  distribution    = try(each.value.distribution, "ByLogStream")
}
