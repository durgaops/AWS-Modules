variable "name" { type = string }
variable "name_prefix" {
  type    = string
  default = null
}
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "key_name" {
  type    = string
  default = null
}
variable "user_data" {
  type    = string
  default = null
}
variable "user_data_base64" {
  type    = string
  default = null
}
variable "ebs_optimized" {
  type    = bool
  default = true
}
variable "update_default_version" {
  type    = bool
  default = true
}
variable "iam_instance_profile_name" {
  type    = string
  default = null
}
variable "iam_instance_profile_arn" {
  type    = string
  default = null
}
variable "block_device_mappings" {
  type = any
  default = [{
    device_name = "/dev/xvda"
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }]
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "imds_http_tokens" {
  type    = string
  default = "required"
}
variable "imds_hop_limit" {
  type    = number
  default = 1
}
variable "instance_metadata_tags" {
  type    = string
  default = "enabled"
}
variable "detailed_monitoring" {
  type    = bool
  default = true
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "associate_public_ip" {
  type    = bool
  default = null
}
variable "placement_group" {
  type    = string
  default = null
}
variable "tenancy" {
  type    = string
  default = null
}
variable "availability_zone" {
  type    = string
  default = null
}
variable "use_spot" {
  type    = bool
  default = false
}
variable "spot_max_price" {
  type    = string
  default = null
}
variable "spot_instance_type" {
  type    = string
  default = "one-time"
}
variable "spot_interruption_behavior" {
  type    = string
  default = "terminate"
}
variable "tags" {
  type    = map(string)
  default = {}
}
