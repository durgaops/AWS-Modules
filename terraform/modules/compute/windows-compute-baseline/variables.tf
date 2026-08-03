variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.large"
}
variable "subnet_id" { type = string }
variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}
variable "create_instance_profile" {
  type    = bool
  default = true
}
variable "iam_instance_profile" {
  type    = string
  default = null
}
variable "additional_managed_policy_arns" {
  type    = list(string)
  default = []
}
variable "permissions_boundary_arn" {
  type    = string
  default = null
}
variable "root_volume_size" {
  type    = number
  default = 50
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "user_data" {
  type    = string
  default = null
}
variable "patch_group" {
  type    = string
  default = "windows-default"
}
variable "tags" {
  type    = map(string)
  default = {}
}
