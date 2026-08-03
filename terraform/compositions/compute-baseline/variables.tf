variable "role_name" {
  type = string
}

variable "managed_policy_arns" {
  type    = list(string)
  default = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

variable "instance_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "root_volume_size" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
