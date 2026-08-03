variable "tgw_name" {
  type = string
}

variable "tgw_description" {
  type    = string
  default = "Enterprise Transit Gateway"
}

variable "tgw_amazon_side_asn" {
  type    = number
  default = 64512
}

variable "tgw_auto_accept_shared_attachments" {
  type    = string
  default = "enable"
}

variable "enable_inspection_vpc" {
  type    = bool
  default = true
}

variable "inspection_vpc_name" {
  type    = string
  default = "inspection"
}

variable "inspection_vpc_cidr" {
  type    = string
  default = null
}

variable "inspection_subnets" {
  type    = list(any)
  default = []
}

variable "inspection_tgw_subnets" {
  type    = list(any)
  default = []
}

variable "enable_network_firewall" {
  type    = bool
  default = true
}

variable "enable_shared_services_vpc" {
  type    = bool
  default = true
}

variable "shared_services_vpc_name" {
  type    = string
  default = "shared-services"
}

variable "shared_services_vpc_cidr" {
  type    = string
  default = null
}

variable "shared_services_public_subnets" {
  type    = list(any)
  default = []
}

variable "shared_services_private_subnets" {
  type    = list(any)
  default = []
}

variable "shared_services_gateway_endpoints" {
  type    = any
  default = {}
}

variable "shared_services_interface_endpoints" {
  type    = any
  default = {}
}

variable "tgw_route_tables" {
  type = any
  default = {
    inspection      = { static_routes = [] }
    shared-services = { static_routes = [] }
    spoke           = { static_routes = [] }
  }
}

variable "inspection_route_table_key" {
  type    = string
  default = "inspection"
}

variable "shared_services_route_table_key" {
  type    = string
  default = "shared-services"
}

variable "additional_tgw_associations" {
  type = map(object({
    attachment_id   = string
    route_table_key = string
  }))
  default = {}
}

variable "tgw_propagations" {
  type = map(object({
    attachment_id   = string
    route_table_key = string
  }))
  default = {}
}

variable "enable_route53_resolver" {
  type    = bool
  default = false
}

variable "resolver_name" {
  type    = string
  default = "enterprise-resolver"
}

variable "resolver_security_group_ids" {
  type    = list(string)
  default = []
}

variable "resolver_create_inbound" {
  type    = bool
  default = true
}

variable "resolver_create_outbound" {
  type    = bool
  default = true
}

variable "resolver_inbound_subnet_ids" {
  type    = list(string)
  default = null
}

variable "resolver_outbound_subnet_ids" {
  type    = list(string)
  default = null
}

variable "resolver_forwarding_rules" {
  type    = any
  default = {}
}

variable "enable_direct_connect" {
  type    = bool
  default = false
}

variable "dx_gateway_name" {
  type    = string
  default = "enterprise-dxgw"
}

variable "dx_amazon_side_asn" {
  type    = number
  default = 64512
}

variable "dx_allowed_prefixes" {
  type    = list(string)
  default = []
}

variable "dx_connections" {
  type    = any
  default = {}
}

variable "tgw_share_principals" {
  description = "Org/account principals to share TGW via RAM"
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
