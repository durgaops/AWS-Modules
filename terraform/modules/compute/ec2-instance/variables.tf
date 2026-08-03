variable "name" { type = string }
variable "ami_id" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "subnet_id" { type = string }
variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}
variable "iam_instance_profile" {
  type    = string
  default = null
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
variable "user_data_replace_on_change" {
  type    = bool
  default = false
}
variable "associate_public_ip" {
  type    = bool
  default = false
}
variable "private_ip" {
  type    = string
  default = null
}
variable "detailed_monitoring" {
  type    = bool
  default = true
}
variable "ebs_optimized" {
  type    = bool
  default = true
}
variable "disable_api_termination" {
  type    = bool
  default = true
}
variable "availability_zone" {
  type    = string
  default = null
}
variable "placement_group" {
  type    = string
  default = null
}
variable "tenancy" {
  type    = string
  default = "default"
}
variable "hibernation" {
  type    = bool
  default = false
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
variable "root_volume_size" {
  type    = number
  default = 30
}
variable "root_volume_type" {
  type    = string
  default = "gp3"
}
variable "root_delete_on_termination" {
  type    = bool
  default = true
}
variable "root_iops" {
  type    = number
  default = null
}
variable "root_throughput" {
  type    = number
  default = null
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "ebs_block_devices" {
  type    = any
  default = []
}
variable "cpu_credits" {
  type    = string
  default = null
}
variable "volume_tags" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
