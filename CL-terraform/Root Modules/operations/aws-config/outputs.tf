output "recorder_id" {
  value = aws_config_configuration_recorder.this.id
}

output "delivery_channel_id" {
  value = aws_config_delivery_channel.this.id
}

output "managed_rule_arns" {
  value = { for k, v in aws_config_config_rule.managed : k => v.arn }
}
