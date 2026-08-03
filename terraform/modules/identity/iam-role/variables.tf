variable "name" {
  description = "IAM role name (without optional prefix)"
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix applied before name (e.g. coe-)"
  type        = string
  default     = null
}

variable "name_regex" {
  description = "Naming convention regex enforced by the module"
  type        = string
  default     = "^(coe|app|plat|sec|cicd|breakglass)-[a-z0-9-]+$"
}

variable "path" {
  type    = string
  default = "/"
}

variable "description" {
  type    = string
  default = "Managed by Terraform identity/iam-role module"
}

variable "assume_role_policy" {
  description = "Trust policy JSON"
  type        = string
}

variable "max_session_duration" {
  description = "Max session duration in seconds (min 3600)"
  type        = number
  default     = 3600
}

variable "max_session_duration_ceiling" {
  description = "Organizational ceiling for session duration"
  type        = number
  default     = 14400
}

variable "permissions_boundary_arn" {
  description = "Optional IAM permissions boundary ARN"
  type        = string
  default     = null
}

variable "require_permission_boundary" {
  description = "Fail if permissions_boundary_arn is not set"
  type        = bool
  default     = false
}

variable "managed_policy_arns" {
  type    = list(string)
  default = []
}

variable "inline_policies" {
  description = "Map of inline policy name => policy JSON"
  type        = map(string)
  default     = {}
}

variable "allow_inline_policies" {
  description = "When false, any inline_policies input fails validation"
  type        = bool
  default     = false
}

variable "max_inline_policies" {
  type    = number
  default = 2
}

variable "allowed_trust_principals" {
  description = "Allow-list of exact trust principals (ARNs/services). Empty = no principal allow-list check."
  type        = list(string)
  default     = []
}

variable "allowed_trust_account_ids" {
  description = "Allow-list of AWS account IDs permitted in trust policy. Empty = no account check."
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  type    = bool
  default = false
}

variable "force_detach_policies" {
  type    = bool
  default = true
}

variable "owner" {
  description = "Owning team (stored as Owner tag)"
  type        = string
  default     = null
}

variable "cost_center" {
  type    = string
  default = null
}

variable "data_classification" {
  type    = string
  default = null
}

variable "required_tag_keys" {
  description = "Tag keys that must be present on every role"
  type        = list(string)
  default     = ["Environment", "Owner", "CostCenter"]
}

variable "tags" {
  description = "Tags applied to the role (must include required_tag_keys)"
  type        = map(string)
  default     = {}
}
