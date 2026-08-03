variable "name" { type = string }
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "server_certificate_arn" { type = string }
variable "client_cidr_block" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }

variable "split_tunnel" {
  type    = bool
  default = true
}
variable "transport_protocol" {
  type    = string
  default = "udp"
}
variable "vpn_port" {
  type    = number
  default = 443
}
variable "dns_servers" {
  type    = list(string)
  default = []
}
variable "self_service_portal" {
  type    = string
  default = "disabled"
}
variable "session_timeout_hours" {
  type    = number
  default = 24
}
variable "authentication_type" {
  type    = string
  default = "certificate-authentication"
}
variable "root_certificate_chain_arn" {
  type    = string
  default = null
}
variable "saml_provider_arn" {
  type    = string
  default = null
}
variable "active_directory_id" {
  type    = string
  default = null
}
variable "connection_logging" {
  type    = bool
  default = false
}
variable "cloudwatch_log_group" {
  type    = string
  default = null
}
variable "cloudwatch_log_stream" {
  type    = string
  default = null
}
variable "authorization_rules" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
