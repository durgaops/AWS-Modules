variable "name" {
  type = string
}

variable "transit_gateway_id" {
  description = "ID of an existing Transit Gateway"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the TGW attachment (typically one per AZ)"
  type        = list(string)
}

variable "dns_support" {
  type    = string
  default = "enable"
}

variable "ipv6_support" {
  type    = string
  default = "disable"
}

variable "appliance_mode_support" {
  type    = string
  default = "disable"
}

variable "tags" {
  type    = map(string)
  default = {}
}
