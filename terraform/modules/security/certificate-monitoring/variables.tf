variable "rule_name" {
  type    = string
  default = "acm-certificate-approaching-expiry"
}
variable "sns_topic_arn" { type = string }
variable "manage_sns_topic_policy" {
  type    = bool
  default = true
}
variable "certificate_arns" {
  description = "Certificates to create DaysToExpiry metric alarms for"
  type        = list(string)
  default     = []
}
variable "expiry_threshold_days" {
  type    = number
  default = 30
}
variable "alarm_name_prefix" {
  type    = string
  default = "acm-days-to-expiry"
}
variable "tags" {
  type    = map(string)
  default = {}
}
