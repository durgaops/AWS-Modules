output "guardduty_detector_id" {
  value = try(module.guardduty[0].detector_id, null)
}
output "security_notifications_topic_arn" {
  value = try(module.notifications[0].sns_topic_arn, null)
}
output "access_analyzer_arn" {
  value = try(module.access_analyzer[0].analyzer_arn, null)
}
output "data_protection" {
  value = {
    s3_public_access_block = module.data_protection.s3_public_access_block_enabled
    ebs_encryption         = module.data_protection.ebs_encryption_by_default_enabled
    imdsv2                 = module.data_protection.imdsv2_enforced
  }
}
output "config_rule_names" {
  value = try(module.config_rules[0].all_rule_names, [])
}
