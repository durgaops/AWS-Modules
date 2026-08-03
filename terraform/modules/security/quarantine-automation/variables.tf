variable "rule_name" {
  type    = string
  default = "security-quarantine-trigger"
}
variable "quarantine_lambda_arn" { type = string }
variable "quarantine_security_group_id" {
  description = "SG applied to quarantined ENIs/instances by the Lambda"
  type        = string
  default     = ""
}
variable "notify_topic_arn" {
  type    = string
  default = ""
}
variable "trigger_severity_labels" {
  type    = list(string)
  default = ["CRITICAL"]
}
variable "event_pattern" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
