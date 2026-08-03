variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "ingress_rules" {
  type    = any
  default = []
}

variable "egress_rules" {
  type    = any
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
