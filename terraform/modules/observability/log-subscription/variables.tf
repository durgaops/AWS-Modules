variable "subscription_filters" {
  description = "List of { name, log_group_name, destination_arn, filter_pattern?, role_arn?, distribution? }"
  type        = any
  default     = []
}
variable "default_role_arn" {
  type    = string
  default = null
}
