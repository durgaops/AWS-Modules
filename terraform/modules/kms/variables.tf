variable "name" {
  description = "Alias name without alias/ prefix (e.g. app-data)"
  type        = string
}

variable "description" {
  description = "KMS key description"
  type        = string
  default     = "Managed by Terraform"
}

variable "deletion_window_in_days" {
  description = "Waiting period before key deletion"
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Enable automatic annual key rotation"
  type        = bool
  default     = true
}

variable "key_policy" {
  description = "Optional custom key policy JSON. Null uses AWS default."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the key"
  type        = map(string)
  default     = {}
}
