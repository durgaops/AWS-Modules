variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "secondary_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "assign_generated_ipv6_cidr_block" {
  type    = bool
  default = false
}

variable "public_subnets" {
  type    = list(any)
  default = []
}

variable "private_subnets" {
  type    = list(any)
  default = []
}

variable "application_subnets" {
  type    = list(any)
  default = []
}

variable "database_subnets" {
  type    = list(any)
  default = []
}

variable "inspection_subnets" {
  type    = list(any)
  default = []
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "nat_mode" {
  type    = string
  default = "centralized"
}

variable "additional_route_tables" {
  type    = any
  default = {}
}

variable "additional_associations" {
  type = map(object({
    subnet_id       = string
    route_table_key = string
  }))
  default = {}
}

variable "enable_flow_logs" {
  type    = bool
  default = false
}

variable "flow_logs_traffic_type" {
  type    = string
  default = "ALL"
}

variable "flow_logs_destination_type" {
  type    = string
  default = "s3"
}

variable "flow_logs_destination_arn" {
  type    = string
  default = null
}

variable "flow_logs_iam_role_arn" {
  type    = string
  default = null
}

variable "gateway_endpoints" {
  type    = any
  default = {}
}

variable "interface_endpoints" {
  type    = any
  default = {}
}

variable "security_groups" {
  description = "Map of SG name => { description?, ingress_rules?, egress_rules? }"
  type        = any
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
