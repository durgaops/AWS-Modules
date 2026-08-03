variable "name" { type = string }

variable "create_endpoint_service" {
  type    = bool
  default = false
}

variable "acceptance_required" {
  type    = bool
  default = true
}

variable "nlb_arns" {
  type    = list(string)
  default = []
}

variable "allowed_principals" {
  type    = list(string)
  default = []
}

variable "private_dns_name" {
  type    = string
  default = null
}

variable "supported_ip_address_types" {
  type    = list(string)
  default = ["ipv4"]
}

variable "create_consumer_endpoint" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "service_name" {
  type    = string
  default = null
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "private_dns_enabled" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
