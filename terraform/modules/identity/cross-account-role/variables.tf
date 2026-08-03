variable "name" {
  type    = string
  default = "plat-cross-account-access"
}
variable "name_prefix" {
  type    = string
  default = null
}
variable "name_regex" {
  type    = string
  default = "^(plat|coe|sec)-[a-z0-9-]+$"
}
variable "description" {
  type    = string
  default = "Standard cross-account access role"
}
variable "trusted_principal_arns" {
  description = "ARNs allowed to assume this role"
  type        = list(string)
}
variable "allowed_trust_account_ids" {
  description = "Account IDs permitted in trust (cross-account validation)"
  type        = list(string)
  default     = []
}
variable "require_external_id" {
  type    = bool
  default = true
}
variable "external_id" {
  type      = string
  default   = null
  sensitive = true
}
variable "require_mfa" {
  type    = bool
  default = false
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
variable "owner" {
  type    = string
  default = "IAM / Cloud Platform"
}
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
