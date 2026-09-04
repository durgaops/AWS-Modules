variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name_prefix" {
  description = "Name prefix for all resources (include env, e.g. payments-dev)"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  description = "Public subnets for IGW/NAT path (required for internet-gateway + nat-gateway wiring)"
  type = list(object({
    cidr_block = string
    az         = string
  }))
  default = []
}

variable "private_subnets" {
  type = list(object({
    cidr_block = string
    az         = string
  }))
}

variable "database_subnets" {
  type = list(object({
    cidr_block = string
    az         = string
  }))
  default = []
}

variable "app_ingress_rules" {
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

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "app_bucket_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
