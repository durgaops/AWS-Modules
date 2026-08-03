variable "compliance_framework" {
  description = "e.g. CIS, NIST, PCI-DSS, SOC2, custom"
  type        = string
  default     = "CIS"
}

variable "managed_rules" {
  type = any
  default = [
    { name = "encrypted-volumes", source_identifier = "ENCRYPTED_VOLUMES" },
    { name = "cloudtrail-enabled", source_identifier = "CLOUD_TRAIL_ENABLED" },
    { name = "root-account-mfa-enabled", source_identifier = "ROOT_ACCOUNT_MFA_ENABLED" },
    { name = "s3-bucket-public-read-prohibited", source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED" },
    { name = "s3-bucket-public-write-prohibited", source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED" },
    { name = "iam-user-mfa-enabled", source_identifier = "IAM_USER_MFA_ENABLED" },
    { name = "multi-region-cloudtrail-enabled", source_identifier = "MULTI_REGION_CLOUD_TRAIL_ENABLED" }
  ]
}

variable "custom_rules" {
  type    = any
  default = []
}

variable "enable_security_hub_standards" {
  type    = bool
  default = true
}

variable "security_hub_standards_arns" {
  type    = list(string)
  default = []
}

variable "required_controls" {
  description = "Human-readable control IDs required for evidence"
  type        = list(string)
  default     = []
}

variable "evidence_bucket_name" {
  type    = string
  default = null
}

variable "evidence_retention_days" {
  type    = number
  default = 365
}

variable "publish_evidence_manifest" {
  type    = bool
  default = true
}

variable "evidence_manifest_parameter_name" {
  type    = string
  default = "/compliance/evidence-manifest"
}

variable "tags" {
  type    = map(string)
  default = {}
}
