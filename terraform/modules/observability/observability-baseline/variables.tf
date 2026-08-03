variable "log_groups" {
  description = "List of { name, retention_in_days?, kms_key_arn? }"
  type        = any
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

variable "default_alarm_actions" {
  type    = list(string)
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

variable "siem_firehose_name" {
  type    = string
  default = "siem-log-forwarder"
}

variable "siem_firehose_destination" {
  type    = string
  default = "http_endpoint"
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

variable "firehose_log_group_name" {
  type    = string
  default = "/aws/kinesisfirehose/siem-forwarder"
}

variable "enable_otel_collector" {
  type    = bool
  default = true
}

variable "otel_collector_name" {
  type    = string
  default = "otel-collector"
}

variable "otel_create_ecs" {
  type    = bool
  default = false
}

variable "otel_create_service" {
  type    = bool
  default = false
}

variable "otel_config_parameter_name" {
  type    = string
  default = "/observability/otel-collector/config"
}

variable "otel_config" {
  type    = string
  default = null
}

variable "otel_execution_role_arn" {
  type    = string
  default = null
}

variable "otel_task_role_arn" {
  type    = string
  default = null
}

variable "otel_ecs_cluster_arn" {
  type    = string
  default = null
}

variable "otel_subnet_ids" {
  type    = list(string)
  default = []
}

variable "otel_security_group_ids" {
  type    = list(string)
  default = []
}

variable "otel_log_group_key" {
  description = "Key in log_groups map used by OTEL (defaults to name)"
  type        = string
  default     = "/ecs/otel-collector"
}

variable "enable_xray" {
  type    = bool
  default = true
}

variable "xray_sampling_rules" {
  type    = any
  default = []
}

variable "xray_groups" {
  type    = any
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
