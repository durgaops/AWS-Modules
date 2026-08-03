variable "name" {
  description = "IAM role name"
  type        = string
}

variable "assume_role_policy" {
  description = "Trust policy JSON for the role"
  type        = string
}

variable "managed_policy_arns" {
  description = "AWS managed or customer managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy name => policy JSON"
  type        = map(string)
  default     = {}
}

variable "max_session_duration" {
  description = "Max session duration in seconds"
  type        = number
  default     = 3600
}

variable "permissions_boundary_arn" {
  description = "Optional permissions boundary ARN"
  type        = string
  default     = null
}

variable "create_instance_profile" {
  description = "Create an instance profile for EC2"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the role"
  type        = map(string)
  default     = {}
}
