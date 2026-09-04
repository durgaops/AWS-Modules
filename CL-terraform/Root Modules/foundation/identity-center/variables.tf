variable "instance_arn" {
  description = "Identity Center instance ARN (auto-detected if null)"
  type        = string
  default     = null
}

variable "identity_store_id" {
  description = "Identity store ID (auto-detected if null)"
  type        = string
  default     = null
}

variable "permission_sets" {
  type = map(object({
    description         = optional(string)
    session_duration    = optional(string, "PT8H")
    relay_state         = optional(string)
    managed_policy_arns = optional(list(string), [])
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "account_assignments" {
  type = map(object({
    permission_set     = string
    principal_id       = string
    principal_type     = string
    target_account_id  = string
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
