variable "recorder_name" {
  type    = string
  default = "default"
}
variable "delivery_channel_name" {
  type    = string
  default = "default"
}
variable "config_role_arn" { type = string }
variable "s3_bucket_name" { type = string }
variable "s3_key_prefix" {
  type    = string
  default = null
}
variable "s3_kms_key_arn" {
  type    = string
  default = null
}
variable "sns_topic_arn" {
  type    = string
  default = null
}
variable "record_all_supported" {
  type    = bool
  default = true
}
variable "include_global_resource_types" {
  type    = bool
  default = true
}
variable "resource_types" {
  type    = list(string)
  default = []
}
variable "recording_frequency" {
  type    = string
  default = null
}
variable "snapshot_delivery_frequency" {
  type    = string
  default = "TwentyFour_Hours"
}
variable "enable_recorder" {
  type    = bool
  default = true
}
