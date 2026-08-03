variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }

variable "create_policy" {
  type    = bool
  default = true
}

variable "policy_name" {
  type    = string
  default = null
}

variable "firewall_policy_arn" {
  type    = string
  default = null
}

variable "stateless_default_actions" {
  type    = list(string)
  default = ["aws:forward_to_sfe"]
}

variable "stateless_fragment_default_actions" {
  type    = list(string)
  default = ["aws:forward_to_sfe"]
}

variable "stateless_rule_group_arns" {
  type    = list(string)
  default = []
}

variable "stateful_rule_group_arns" {
  type    = list(string)
  default = []
}

variable "delete_protection" {
  type    = bool
  default = false
}

variable "firewall_policy_change_protection" {
  type    = bool
  default = false
}

variable "subnet_change_protection" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
