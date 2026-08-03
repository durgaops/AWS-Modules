variable "topic_name" {
  type    = string
  default = "ops-incidents"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "primary_tool" {
  description = "pagerduty or servicenow"
  type        = string
  default     = "pagerduty"
}
variable "pagerduty_endpoint" {
  description = "PagerDuty Events HTTPS integration URL"
  type        = string
  default     = null
}
variable "servicenow_endpoint" {
  description = "ServiceNow inbound HTTPS webhook"
  type        = string
  default     = null
}
variable "extra_subscriptions" {
  type    = any
  default = []
}
variable "enable_alarm_event_routing" {
  type    = bool
  default = true
}
variable "alarm_states" {
  type    = list(string)
  default = ["ALARM"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
