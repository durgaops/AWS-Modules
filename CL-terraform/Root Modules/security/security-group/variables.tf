variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Managed by Terraform"
}

variable "vpc_id" {
  type = string
}

variable "ingress_rules" {
  type = list(object({
    name                     = string
    protocol                 = string
    from_port                = optional(number)
    to_port                  = optional(number)
    cidr_ipv4                = optional(string)
    cidr_ipv6                = optional(string)
    source_security_group_id = optional(string)
    prefix_list_id           = optional(string)
    description              = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  type = list(object({
    name                     = string
    protocol                 = string
    from_port                = optional(number)
    to_port                  = optional(number)
    cidr_ipv4                = optional(string)
    cidr_ipv6                = optional(string)
    source_security_group_id = optional(string)
    prefix_list_id           = optional(string)
    description              = optional(string)
  }))
  default = [{
    name        = "allow-all-egress"
    protocol    = "-1"
    cidr_ipv4   = "0.0.0.0/0"
    description = "Allow all egress"
  }]
}

variable "tags" {
  type    = map(string)
  default = {}
}
