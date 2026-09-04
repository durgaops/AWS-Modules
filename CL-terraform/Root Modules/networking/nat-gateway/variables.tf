variable "name_prefix" {
  description = "Name prefix for EIP and NAT Gateway resources"
  type        = string
}

variable "public_subnet_ids" {
  description = "Map of keys to public subnet IDs where NAT Gateways are placed"
  type        = map(string)
}

variable "connectivity_type" {
  description = "Connectivity type for the NAT Gateway (public or private)"
  type        = string
  default     = "public"
}

variable "tags" {
  type    = map(string)
  default = {}
}
