variable "name" {
  type    = string
  default = "bastion"
}
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "subnet_id" { type = string }
variable "vpc_security_group_ids" { type = list(string) }
variable "iam_instance_profile" {
  type    = string
  default = null
}
variable "key_name" {
  type    = string
  default = null
}
variable "associate_public_ip" {
  type    = bool
  default = false
}
variable "disable_api_termination" {
  type    = bool
  default = true
}
variable "root_volume_size" {
  type    = number
  default = 20
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "approval_ticket" {
  description = "Required change ticket authorizing bastion (prefer SSM)"
  type        = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
