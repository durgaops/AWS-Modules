output "managed_rule_arns" {
  value = { for k, r in aws_config_config_rule.managed : k => r.arn }
}
output "custom_rule_arns" {
  value = { for k, r in aws_config_config_rule.custom : k => r.arn }
}
output "all_rule_names" {
  value = concat(keys(aws_config_config_rule.managed), keys(aws_config_config_rule.custom))
}
