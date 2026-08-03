variable "name" { type = string }
variable "load_balancer_type" {
  description = "application or network"
  type        = string
  default     = "application"
}
variable "internal" {
  type    = bool
  default = false
}
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "vpc_id" { type = string }
variable "ip_address_type" {
  type    = string
  default = "ipv4"
}
variable "enable_deletion_protection" {
  type    = bool
  default = false
}
variable "idle_timeout" {
  type    = number
  default = 60
}
variable "access_logs_bucket" {
  type    = string
  default = null
}
variable "access_logs_prefix" {
  type    = string
  default = null
}
variable "target_groups" {
  type    = any
  default = {}
}
variable "listeners" {
  type    = any
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
