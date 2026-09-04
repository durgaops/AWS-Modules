variable "name" {
  description = "Name tag for the flow log"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to enable flow logs on"
  type        = string
}

variable "traffic_type" {
  description = "Type of traffic to capture (ACCEPT, REJECT, or ALL)"
  type        = string
  default     = "ALL"
}

variable "destination_type" {
  description = "Destination for flow logs: cloud-watch-logs or s3"
  type        = string

  validation {
    condition     = contains(["cloud-watch-logs", "s3"], var.destination_type)
    error_message = "destination_type must be cloud-watch-logs or s3."
  }
}

variable "log_destination_arn" {
  description = "ARN of CloudWatch Log Group or S3 bucket for flow logs"
  type        = string
}

variable "iam_role_arn" {
  description = "IAM role ARN for CloudWatch Logs delivery (required when destination_type is cloud-watch-logs)"
  type        = string
  default     = null
}

variable "log_format" {
  description = "Optional custom flow log format"
  type        = string
  default     = null
}

variable "max_aggregation_interval" {
  description = "Maximum aggregation interval in seconds (60 or 600)"
  type        = number
  default     = 600
}

variable "tags" {
  type    = map(string)
  default = {}
}
