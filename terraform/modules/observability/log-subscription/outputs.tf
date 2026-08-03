output "subscription_filter_names" {
  value = keys(aws_cloudwatch_log_subscription_filter.this)
}
output "subscription_filter_ids" {
  value = { for k, f in aws_cloudwatch_log_subscription_filter.this : k => f.id }
}
