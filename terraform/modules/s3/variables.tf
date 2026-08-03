variable "bucket_name" {
  description = "S3 bucket name (globally unique)"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even if not empty"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable object versioning"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for SSE-KMS. Null uses SSE-S3."
  type        = string
  default     = null
}

variable "block_public_access" {
  description = "Block all public access"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "Optional lifecycle rules"
  type = list(object({
    id              = string
    enabled         = bool
    expiration_days = optional(number)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags applied to the bucket"
  type        = map(string)
  default     = {}
}
