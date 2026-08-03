variable "name" {
  type    = string
  default = "breakglass-emergency-admin"
}
variable "name_prefix" {
  type    = string
  default = null
}
variable "description" {
  type    = string
  default = "Controlled emergency access — MFA required"
}
variable "trusted_principal_arns" {
  type = list(string)
}
variable "allowed_trust_account_ids" {
  type    = list(string)
  default = []
}
variable "allowed_source_ips" {
  type    = list(string)
  default = null
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
  default = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
variable "approval_ticket" {
  description = "Change/incident ticket authorizing this break-glass role"
  type        = string
}
variable "review_cadence" {
  type    = string
  default = "90d"
}
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
variable "tags" {
  type    = map(string)
  default = {}
}
