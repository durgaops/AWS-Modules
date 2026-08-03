variable "topic_name" {
  type    = string
  default = "security-findings"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "subscriptions" {
  description = "List of { protocol, endpoint, filter_policy?, raw_message_delivery? } — https/sqs/email/lambda for SIEM/ServiceNow"
  type        = any
  default     = []
}
variable "enable_security_hub_forwarding" {
  type    = bool
  default = true
}
variable "security_hub_severity_labels" {
  type    = list(string)
  default = ["HIGH", "CRITICAL"]
}
variable "enable_guardduty_forwarding" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
