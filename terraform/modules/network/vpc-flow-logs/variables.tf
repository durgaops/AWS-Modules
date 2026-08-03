variable "name" { type = string }
variable "vpc_id" { type = string }

variable "traffic_type" {
  description = "ACCEPT, REJECT, or ALL"
  type        = string
  default     = "ALL"
}

variable "max_aggregation_interval" {
  type    = number
  default = 60
}

variable "log_destination_type" {
  description = "cloud-watch-logs or s3"
  type        = string
  default     = "s3"
}

variable "log_destination_arn" {
  description = "CloudWatch Log Group ARN or S3 bucket ARN"
  type        = string
}

variable "iam_role_arn" {
  description = "Required when destination is cloud-watch-logs"
  type        = string
  default     = null
}

variable "log_format" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
