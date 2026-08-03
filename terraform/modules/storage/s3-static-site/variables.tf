variable "bucket_name" { type = string }
variable "kms_key_arn" { type = string; default = null }
variable "index_document" { type = string; default = "index.html" }
variable "error_document" { type = string; default = "error.html" }
variable "logging" {
  type = object({
    target_bucket = string
    target_prefix = optional(string, "static-site-logs/")
  })
  default = null
}
variable "cloudfront_oai_iam_arn" {
  description = "CloudFront OAI IAM ARN allowed to GetObject (private origin pattern)"
  type        = string
}
variable "required_tag_keys" {
  type    = list(string)
  default = ["Environment", "Owner", "CostCenter"]
}
variable "tags" { type = map(string); default = {} }
