variable "alias" {
  type    = string
  default = "amp-observability"
}
variable "log_group_arn" {
  type    = string
  default = null
}
variable "alert_manager_definition" {
  type    = string
  default = null
}
variable "rule_groups" {
  description = "List of { name, data } YAML rule group namespaces"
  type        = any
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
