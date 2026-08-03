variable "name" { type = string }
variable "internal" {
  type    = bool
  default = true
}
variable "subnet_ids" { type = list(string) }
variable "ip_address_type" {
  type    = string
  default = "ipv4"
}
variable "enable_deletion_protection" {
  type    = bool
  default = true
}
variable "enable_cross_zone_load_balancing" {
  type    = bool
  default = true
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
