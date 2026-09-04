variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Enterprise Transit Gateway"
}

variable "amazon_side_asn" {
  type    = number
  default = 64512
}

variable "auto_accept_shared_attachments" {
  type    = string
  default = "enable"
}

variable "default_route_table_association" {
  type    = string
  default = "disable"
}

variable "default_route_table_propagation" {
  type    = string
  default = "disable"
}

variable "dns_support" {
  type    = string
  default = "enable"
}

variable "vpn_ecmp_support" {
  type    = string
  default = "enable"
}

variable "transit_gateway_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "vpc_attachments" {
  type = map(object({
    vpc_id                 = string
    subnet_ids             = list(string)
    dns_support            = optional(string, "enable")
    appliance_mode_support = optional(string, "disable")
    tags                   = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
