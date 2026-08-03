variable "forwarders" {
  description = "Subscription filters to SIEM destination / Firehose"
  type        = any
  default     = []
}
variable "subscription_role_arn" {
  type    = string
  default = null
}
variable "create_firehose" {
  type    = bool
  default = false
}
variable "firehose_name" {
  type    = string
  default = "siem-log-forwarder"
}
variable "firehose_destination" {
  description = "http_endpoint or extended_s3"
  type        = string
  default     = "http_endpoint"
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
variable "backup_bucket_arn" {
  type    = string
  default = null
}
variable "buffering_size" {
  type    = number
  default = 5
}
variable "buffering_interval" {
  type    = number
  default = 60
}
variable "s3_backup_mode" {
  type    = string
  default = "FailedDataOnly"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "firehose_log_group_name" {
  type    = string
  default = "/aws/kinesisfirehose/siem-forwarder"
}
variable "tags" {
  type    = map(string)
  default = {}
}
