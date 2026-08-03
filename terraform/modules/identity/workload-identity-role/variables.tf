variable "name" { type = string }
variable "workload_name" {
  description = "Application/workload identifier"
  type        = string
}
variable "name_prefix" {
  type    = string
  default = null
}
variable "name_regex" {
  type    = string
  default = "^(app|plat)-[a-z0-9-]+$"
}
variable "description" {
  type    = string
  default = "Workload identity role"
}
variable "trusted_service_principals" {
  type    = list(string)
  default = ["ec2.amazonaws.com"]
}
variable "trusted_aws_principals" {
  type    = list(string)
  default = []
}
variable "trust_actions" {
  type    = list(string)
  default = ["sts:AssumeRole"]
}
variable "trust_conditions" {
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}
variable "max_session_duration" {
  type    = number
  default = 3600
}
variable "permissions_boundary_arn" {
  type    = string
  default = null
}
variable "require_permission_boundary" {
  type    = bool
  default = true
}
variable "managed_policy_arns" {
  type    = list(string)
  default = []
}
variable "allow_inline_policies" {
  type    = bool
  default = false
}
variable "inline_policies" {
  type    = map(string)
  default = {}
}
variable "create_instance_profile" {
  type    = bool
  default = false
}
variable "allowed_trust_account_ids" {
  type    = list(string)
  default = []
}
variable "owner" {
  type    = string
  default = "Security / Platform"
}
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
