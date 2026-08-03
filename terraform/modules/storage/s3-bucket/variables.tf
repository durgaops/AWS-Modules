variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "name_regex" {
  description = "Naming convention regex enforced by the module"
  type        = string
  default     = "^(coe|app|plat|sec|log|bck)-[a-z0-9-]+$"
}

variable "force_destroy" {
  description = "Allow destroy even if bucket contains objects (keep false in prod)"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key ARN for SSE-KMS. Null uses AES256 only if allow_sse_s3=true."
  type        = string
  default     = null
}

variable "allow_sse_s3" {
  description = "Permit AES256 when kms_key_arn is null. Enterprise default is false."
  type        = bool
  default     = false
}

variable "require_kms" {
  description = "Fail when kms_key_arn is not provided"
  type        = bool
  default     = true
}

variable "bucket_key_enabled" {
  type    = bool
  default = true
}

variable "versioning_enabled" {
  description = "Bucket versioning (recommended always on)"
  type        = bool
  default     = true
}

variable "require_versioning" {
  description = "Fail when versioning_enabled is false"
  type        = bool
  default     = true
}

variable "logging" {
  description = "Server access logging target. Required when require_access_logging=true."
  type = object({
    target_bucket = string
    target_prefix = optional(string, "s3-access-logs/")
  })
  default = null
}

variable "require_access_logging" {
  type    = bool
  default = true
}

variable "lifecycle_rules" {
  description = "Optional lifecycle rules (id, transitions, expirations)"
  type = list(object({
    id                                 = string
    enabled                            = optional(bool, true)
    prefix                             = optional(string, null)
    expiration_days                    = optional(number, null)
    noncurrent_version_expiration_days = optional(number, null)
    abort_incomplete_multipart_days    = optional(number, 7)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
  }))
  default = []
}

variable "enable_object_lock" {
  description = "Enable Object Lock at bucket creation (immutable once set)"
  type        = bool
  default     = false
}

variable "object_lock_configuration" {
  description = "Default Object Lock retention when enable_object_lock=true"
  type = object({
    mode = optional(string, "GOVERNANCE") # GOVERNANCE | COMPLIANCE
    days = optional(number, 30)
  })
  default = {
    mode = "GOVERNANCE"
    days = 30
  }
}

variable "replication" {
  description = "Optional CRR/CAR configuration"
  type = object({
    role_arn                = string
    destination_bucket_arn  = string
    destination_kms_key_arn = optional(string, null)
    storage_class           = optional(string, null)
    replica_kms_key_id      = optional(string, null)
    metrics_enabled         = optional(bool, true)
    replication_time_minutes = optional(number, 15)
  })
  default = null
}

variable "access_points" {
  description = "Map of named access points with optional VPC restriction and policy JSON"
  type = map(object({
    name            = string
    vpc_id          = optional(string, null)
    policy          = optional(string, null)
    public_access_block = optional(object({
      block_public_acls       = optional(bool, true)
      block_public_policy     = optional(bool, true)
      ignore_public_acls      = optional(bool, true)
      restrict_public_buckets = optional(bool, true)
    }), {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    })
  }))
  default = {}
}

variable "require_vpc_access_points" {
  description = "Fail if any access point is not VPC-restricted"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Optional additional/custom bucket policy JSON. Module always merges DenyInsecureTransport + DenyPublic."
  type        = string
  default     = null
}

variable "deny_insecure_transport" {
  type    = bool
  default = true
}

variable "deny_unencrypted_uploads" {
  type    = bool
  default = true
}

variable "required_tag_keys" {
  description = "Tag keys that must be present"
  type        = list(string)
  default     = ["Environment", "Owner", "CostCenter", "DataClassification"]
}

variable "owner" {
  type    = string
  default = null
}

variable "cost_center" {
  type    = string
  default = null
}

variable "data_classification" {
  type    = string
  default = null
}

variable "tags" {
  description = "Tags applied to the bucket (must include required_tag_keys)"
  type        = map(string)
  default     = {}
}
