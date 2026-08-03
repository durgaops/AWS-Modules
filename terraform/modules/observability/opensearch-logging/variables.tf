variable "domain_name" { type = string }
variable "engine_version" {
  type    = string
  default = "OpenSearch_2.11"
}
variable "instance_type" {
  type    = string
  default = "r6g.large.search"
}
variable "instance_count" {
  type    = number
  default = 2
}
variable "dedicated_master_enabled" {
  type    = bool
  default = false
}
variable "dedicated_master_type" {
  type    = string
  default = "r6g.large.search"
}
variable "dedicated_master_count" {
  type    = number
  default = 3
}
variable "zone_awareness_enabled" {
  type    = bool
  default = true
}
variable "availability_zone_count" {
  type    = number
  default = 2
}
variable "ebs_volume_size" {
  type    = number
  default = 100
}
variable "ebs_volume_type" {
  type    = string
  default = "gp3"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "enable_fine_grained_access" {
  type    = bool
  default = true
}
variable "master_user_name" {
  type    = string
  default = "osadmin"
}
variable "master_user_password" {
  type      = string
  default   = null
  sensitive = true
}
variable "vpc_enabled" {
  type    = bool
  default = true
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "application_log_group_arn" {
  type    = string
  default = null
}
variable "access_policy" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
