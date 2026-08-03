variable "name" { type = string }
variable "cidr_block" { type = string }

variable "inspection_subnets" {
  description = "Firewall/inspection subnets [{cidr_block, az}]"
  type        = list(any)
}

variable "tgw_subnets" {
  description = "TGW attachment subnets (stored as private tier) [{cidr_block, az}]"
  type        = list(any)
  default     = []
}

variable "enable_network_firewall" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
