# Combined account security baseline composition module.

module "data_protection" {
  source = "../data-protection-baseline"

  enable_s3_account_public_access_block = var.enable_s3_account_public_access_block
  enable_ebs_encryption_by_default      = var.enable_ebs_encryption_by_default
  ebs_default_kms_key_arn               = var.ebs_default_kms_key_arn
  enforce_imdsv2                        = var.enforce_imdsv2
  block_public_amis                     = var.block_public_amis
}

module "access_analyzer" {
  source = "../access-analyzer"
  count  = var.enable_access_analyzer ? 1 : 0

  analyzer_name                  = var.access_analyzer_name
  analyzer_type                  = var.access_analyzer_type
  enable_unused_access_analyzer  = var.enable_unused_access_analyzer
  tags                           = var.tags
}

module "guardduty" {
  source = "../guardduty"
  count  = var.enable_guardduty ? 1 : 0

  name                           = var.guardduty_name
  finding_publishing_frequency   = var.guardduty_finding_frequency
  publishing_destination_arn     = var.guardduty_publishing_destination_arn
  publishing_kms_key_arn         = var.guardduty_publishing_kms_key_arn
  tags                           = var.tags
}

module "security_hub" {
  source = "../security-hub"
  count  = var.enable_security_hub ? 1 : 0

  enable_default_standards = var.security_hub_enable_default_standards
  standards_arns           = var.security_hub_standards_arns
}

module "notifications" {
  source = "../security-notifications"
  count  = var.enable_security_notifications ? 1 : 0

  topic_name                     = var.notifications_topic_name
  kms_key_arn                    = var.notifications_kms_key_arn
  subscriptions                  = var.notifications_subscriptions
  enable_security_hub_forwarding = var.enable_security_hub
  enable_guardduty_forwarding    = var.enable_guardduty
  security_hub_severity_labels  = var.notification_severity_labels
  tags                           = var.tags
}

module "config_rules" {
  source = "../config-rules"
  count  = var.enable_config_rules ? 1 : 0

  managed_rules = length(var.config_managed_rules) > 0 ? var.config_managed_rules : [
    { name = "encrypted-volumes", source_identifier = "ENCRYPTED_VOLUMES" },
    { name = "root-account-mfa-enabled", source_identifier = "ROOT_ACCOUNT_MFA_ENABLED" },
    { name = "s3-bucket-public-read-prohibited", source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED" }
  ]
  custom_rules = var.config_custom_rules
  tags         = var.tags
}
