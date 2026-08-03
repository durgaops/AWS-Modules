variable "s3_policies" {
  description = "Map of name => { bucket_arn, deny_public? }"
  type        = any
  default     = {}
}
variable "kms_policies" {
  description = "Map of name => { account_id, allowed_service_principals?, service_actions? }"
  type        = any
  default     = {}
}
variable "sns_policies" {
  description = "Map of name => { topic_arn }"
  type        = any
  default     = {}
}
variable "sqs_policies" {
  description = "Map of name => { queue_arn }"
  type        = any
  default     = {}
}
