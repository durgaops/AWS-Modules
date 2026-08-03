variable "name" { type = string }
variable "destination" {
  type    = string
  default = "extended_s3"
}
variable "role_arn" { type = string }
variable "s3_bucket_arn" { type = string }
variable "s3_prefix" {
  type    = string
  default = "logs/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
}
variable "s3_error_prefix" {
  type    = string
  default = "errors/"
}
variable "buffering_size" {
  type    = number
  default = 5
}
variable "buffering_interval" {
  type    = number
  default = 300
}
variable "compression_format" {
  type    = string
  default = "GZIP"
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "processor_lambda_arn" {
  type    = string
  default = null
}
variable "cloudwatch_log_group_name" {
  type    = string
  default = null
}
variable "http_endpoint_url" {
  type    = string
  default = null
}
variable "http_endpoint_name" {
  type    = string
  default = null
}
variable "http_endpoint_access_key" {
  type      = string
  default   = null
  sensitive = true
}
variable "s3_backup_mode" {
  type    = string
  default = "FailedDataOnly"
}
variable "tags" {
  type    = map(string)
  default = {}
}
