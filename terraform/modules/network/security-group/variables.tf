variable "name" { type = string }
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "vpc_id" { type = string }

variable "ingress_rules" {
  description = "List of ingress rules"
  type        = any
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules (default: allow all IPv4)"
  type        = any
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
