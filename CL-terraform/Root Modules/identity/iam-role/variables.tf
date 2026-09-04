variable "role_name" {
  type = string
}

variable "assume_role_policy" {
  description = "IAM trust policy JSON for the role"
  type        = string
}

variable "description" {
  type    = string
  default = null
}

variable "path" {
  type    = string
  default = "/"
}

variable "max_session_duration" {
  type    = number
  default = 3600
}

variable "permissions_boundary_arn" {
  type    = string
  default = null
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy name => JSON document"
  type        = map(string)
  default     = {}
}

variable "create_instance_profile" {
  description = "Create an IAM instance profile for this role"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
