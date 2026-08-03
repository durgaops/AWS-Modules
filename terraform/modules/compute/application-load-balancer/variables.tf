variable "name" { type = string }
variable "internal" {
  type    = bool
  default = false
}
variable "security_group_ids" { type = list(string) }
variable "subnet_ids" { type = list(string) }
variable "ip_address_type" {
  type    = string
  default = "ipv4"
}
variable "idle_timeout" {
  type    = number
  default = 60
}
variable "drop_invalid_header_fields" {
  type    = bool
  default = true
}
variable "enable_deletion_protection" {
  type    = bool
  default = true
}
variable "enable_http2" {
  type    = bool
  default = true
}
variable "desync_mitigation_mode" {
  type    = string
  default = "defensive"
}
variable "access_logs_bucket" {
  type    = string
  default = null
}
variable "access_logs_prefix" {
  type    = string
  default = null
}
variable "listeners" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
