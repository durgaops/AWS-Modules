variable "vpc_id" {
  description = "VPC ID for all route tables in this module"
  type        = string
}

variable "route_tables" {
  description = "Map of route tables to create, keyed by a stable name"
  type = map(object({
    name = optional(string)
    tags = optional(map(string), {})
    routes = optional(list(object({
      destination_cidr_block      = optional(string)
      destination_ipv6_cidr_block = optional(string)
      gateway_id                  = optional(string)
      nat_gateway_id              = optional(string)
      transit_gateway_id          = optional(string)
      vpc_peering_connection_id   = optional(string)
      network_interface_id        = optional(string)
      vpc_endpoint_id             = optional(string)
      egress_only_gateway_id      = optional(string)
    })), [])
    subnet_ids = optional(list(string), [])
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
