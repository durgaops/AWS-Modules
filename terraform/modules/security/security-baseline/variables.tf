variable "enable_s3_account_public_access_block" {
  type    = bool
  default = true
}
variable "enable_ebs_encryption_by_default" {
  type    = bool
  default = true
}
variable "ebs_default_kms_key_arn" {
  type    = string
  default = null
}
variable "enforce_imdsv2" {
  type    = bool
  default = true
}
variable "block_public_amis" {
  type    = bool
  default = true
}

variable "enable_access_analyzer" {
  type    = bool
  default = true
}
variable "access_analyzer_name" {
  type    = string
  default = "external-access"
}
variable "access_analyzer_type" {
  type    = string
  default = "ACCOUNT"
}
variable "enable_unused_access_analyzer" {
  type    = bool
  default = false
}

variable "enable_guardduty" {
  type    = bool
  default = true
}
variable "guardduty_name" {
  type    = string
  default = "guardduty"
}
variable "guardduty_finding_frequency" {
  type    = string
  default = "FIFTEEN_MINUTES"
}
variable "guardduty_publishing_destination_arn" {
  type    = string
  default = null
}
variable "guardduty_publishing_kms_key_arn" {
  type    = string
  default = null
}

variable "enable_security_hub" {
  type    = bool
  default = true
}
variable "security_hub_enable_default_standards" {
  type    = bool
  default = false
}
variable "security_hub_standards_arns" {
  type    = list(string)
  default = []
}

variable "enable_security_notifications" {
  type    = bool
  default = true
}
variable "notifications_topic_name" {
  type    = string
  default = "security-findings"
}
variable "notifications_kms_key_arn" {
  type    = string
  default = null
}
variable "notifications_subscriptions" {
  type    = any
  default = []
}
variable "notification_severity_labels" {
  type    = list(string)
  default = ["HIGH", "CRITICAL"]
}

variable "enable_config_rules" {
  type    = bool
  default = false
}
variable "config_managed_rules" {
  type    = any
  default = []
}
variable "config_custom_rules" {
  type    = any
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
