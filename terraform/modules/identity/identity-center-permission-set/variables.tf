variable "name" { type = string }
variable "description" {
  type    = string
  default = "Managed by Terraform"
}
variable "instance_arn" {
  description = "SSO instance ARN; defaults to the account's Identity Center instance"
  type        = string
  default     = null
}
variable "session_duration" {
  description = "ISO-8601 duration, e.g. PT1H, PT4H"
  type        = string
  default     = "PT1H"
}
variable "relay_state" {
  type    = string
  default = null
}
variable "managed_policy_arns" {
  type    = list(string)
  default = []
}
variable "customer_managed_policies" {
  description = "List of { name, path? }"
  type        = list(any)
  default     = []
}
variable "inline_policy" {
  type    = string
  default = null
}
variable "permissions_boundary" {
  description = "{ managed_policy_arn? } or { customer_managed_policy = { name, path? } }"
  type        = any
  default     = null
}
variable "owner" {
  type    = string
  default = "IAM Team"
}
variable "tags" {
  type    = map(string)
  default = {}
}
