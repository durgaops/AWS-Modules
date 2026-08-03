variable "vpc_id" { type = string }

variable "gateway_endpoints" {
  description = "Map of name => { service_name, route_table_ids?, policy? }"
  type        = any
  default     = {}
}

variable "interface_endpoints" {
  description = "Map of name => { service_name, subnet_ids?, security_group_ids?, private_dns_enabled?, policy? }"
  type        = any
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
