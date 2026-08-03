variable "name" { type = string }
variable "security_group_ids" { type = list(string) }

variable "create_inbound" {
  type    = bool
  default = true
}

variable "create_outbound" {
  type    = bool
  default = true
}

variable "inbound_subnet_ids" {
  type    = list(string)
  default = []
}

variable "outbound_subnet_ids" {
  type    = list(string)
  default = []
}

variable "forwarding_rules" {
  description = "Map of rule_name => { domain_name, target_ips = [{ip,port?}], vpc_ids = [] }"
  type        = any
  default     = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
