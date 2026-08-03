variable "name" { type = string }
variable "cidr_block" { type = string }
variable "public_subnets" { type = list(any) }
variable "private_subnets" { type = list(any) }

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "nat_mode" {
  type    = string
  default = "centralized"
}

variable "tags" {
  type    = map(string)
  default = {}
}
