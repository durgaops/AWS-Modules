variable "name" {
  type    = string
  default = "amg-observability"
}
variable "account_access_type" {
  type    = string
  default = "CURRENT_ACCOUNT"
}
variable "authentication_providers" {
  type    = list(string)
  default = ["AWS_SSO"]
}
variable "permission_type" {
  type    = string
  default = "SERVICE_MANAGED"
}
variable "role_arn" {
  type    = string
  default = null
}
variable "data_sources" {
  type    = list(string)
  default = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
}
variable "notification_destinations" {
  type    = list(string)
  default = ["SNS"]
}
variable "grafana_version" {
  type    = string
  default = "9.4"
}
variable "vpc_configuration" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}
variable "role_associations" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
