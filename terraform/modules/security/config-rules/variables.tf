variable "managed_rules" {
  description = "List of managed rules: { name, source_identifier, description?, input_parameters?, scope?, maximum_execution_frequency? }"
  type        = any
  default = [
    { name = "encrypted-volumes", source_identifier = "ENCRYPTED_VOLUMES" },
    { name = "root-account-mfa-enabled", source_identifier = "ROOT_ACCOUNT_MFA_ENABLED" },
    { name = "iam-password-policy", source_identifier = "IAM_PASSWORD_POLICY" },
    { name = "s3-bucket-public-read-prohibited", source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED" },
    { name = "s3-bucket-ssl-requests-only", source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY" }
  ]
}

variable "custom_rules" {
  description = "List of custom Lambda rules"
  type        = any
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
