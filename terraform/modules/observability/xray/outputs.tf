output "sampling_rule_arns" {
  value = { for k, r in aws_xray_sampling_rule.this : k => r.arn }
}
output "group_arns" {
  value = { for k, g in aws_xray_group.this : k => g.arn }
}
