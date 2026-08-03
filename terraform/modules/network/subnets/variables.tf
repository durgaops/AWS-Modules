variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "public_subnets" {
  description = "List of { cidr_block, az, name?, map_public_ip_on_launch?, ipv6_cidr_block? }"
  type        = list(any)
  default     = []
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

variable "tags" {
  type    = map(string)
  default = {}
}
