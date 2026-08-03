variable "name" {
  type    = string
  default = "org-cloudtrail"
}
variable "s3_bucket_name" { type = string }
variable "s3_key_prefix" {
  type    = string
  default = null
}
variable "include_global_service_events" {
  type    = bool
  default = true
}
variable "is_multi_region_trail" {
  type    = bool
  default = true
}
variable "enable_log_file_validation" {
  type    = bool
  default = true
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "cloud_watch_logs_group_arn" {
  type    = string
  default = null
}
variable "cloud_watch_logs_role_arn" {
  type    = string
  default = null
}
variable "sns_topic_name" {
  type    = string
  default = null
}
variable "enable_logging" {
  type    = bool
  default = true
}
variable "event_selectors" {
  type    = any
  default = []
}
variable "insight_selectors" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
