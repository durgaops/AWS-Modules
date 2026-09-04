variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    cidr_block              = string
    az                      = string
    map_public_ip_on_launch = optional(bool, true)
    tags                    = optional(map(string), {})
  }))
  default = []
}

variable "private_subnets" {
  type = list(object({
    cidr_block = string
    az         = string
    tags       = optional(map(string), {})
  }))
  default = []
}

variable "database_subnets" {
  type = list(object({
    cidr_block = string
    az         = string
    tags       = optional(map(string), {})
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
