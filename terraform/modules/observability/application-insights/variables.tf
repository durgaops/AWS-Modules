variable "resource_group_name" { type = string }
variable "create_resource_group" {
  type    = bool
  default = false
}
variable "resource_group_query" {
  description = "JSON resource query when create_resource_group=true"
  type        = string
  default     = null
}
variable "auto_config_enabled" {
  type    = bool
  default = true
}
variable "auto_create" {
  type    = bool
  default = false
}
variable "cwe_monitor_enabled" {
  type    = bool
  default = true
}
variable "ops_center_enabled" {
  type    = bool
  default = false
}
variable "ops_item_sns_topic_arn" {
  type    = string
  default = null
}
variable "grouping_type" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
