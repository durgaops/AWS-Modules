variable "log_groups" {
  type = any
  default = [
    { name = "/platform/application", retention_in_days = 90 },
    { name = "/platform/infrastructure", retention_in_days = 90 },
    { name = "/ecs/otel-collector", retention_in_days = 30 }
  ]
}
variable "default_log_retention_days" {
  type    = number
  default = 90
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "create_alert_topic" {
  type    = bool
  default = true
}
variable "alert_topic_name" {
  type    = string
  default = "observability-alerts"
}
variable "alert_subscriptions" {
  type    = any
  default = []
}
variable "alarms" {
  type    = any
  default = []
}
variable "dashboards" {
  type    = any
  default = []
}
variable "enable_log_forwarder" {
  type    = bool
  default = false
}
variable "log_forwarders" {
  type    = any
  default = []
}
variable "log_subscription_role_arn" {
  type    = string
  default = null
}
variable "create_siem_firehose" {
  type    = bool
  default = false
}
variable "siem_endpoint_url" {
  type    = string
  default = null
}
variable "siem_name" {
  type    = string
  default = "splunk"
}
variable "siem_access_key" {
  type      = string
  default   = null
  sensitive = true
}
variable "firehose_role_arn" {
  type    = string
  default = null
}
variable "siem_backup_bucket_arn" {
  type    = string
  default = null
}
variable "enable_otel_collector" {
  type    = bool
  default = true
}
variable "otel_create_ecs" {
  type    = bool
  default = false
}
variable "enable_xray" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
