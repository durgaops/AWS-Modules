variable "vpc_id" {
  type = string
}

variable "gateway_endpoints" {
  type = map(object({
    service_name    = string
    route_table_ids = optional(list(string), [])
    tags            = optional(map(string), {})
  }))
  default = {}
}

variable "interface_endpoints" {
  type = map(object({
    service_name        = string
    subnet_ids          = list(string)
    security_group_ids  = optional(list(string), [])
    private_dns_enabled = optional(bool, true)
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
