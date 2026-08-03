variable "name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "cidr_block" {
  description = "Primary IPv4 CIDR"
  type        = string
}

variable "secondary_cidr_blocks" {
  description = "Additional IPv4 CIDRs associated to the VPC"
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = "VPC tenancy (default or dedicated)"
  type        = string
  default     = "default"
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
  description = "Assign an Amazon-provided IPv6 CIDR"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
