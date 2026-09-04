variable "log_groups" {
  type = map(object({
    retention_in_days = optional(number)
    kms_key_id        = optional(string)
    tags              = optional(map(string), {})
  }))
  default = {}
}

variable "default_retention_days" {
  type    = number
  default = 30
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "alarms" {
  type = map(object({
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = optional(string)
    alarm_actions       = optional(list(string), [])
    ok_actions          = optional(list(string), [])
    treat_missing_data  = optional(string, "missing")
    dimensions          = optional(map(string), {})
    tags                = optional(map(string), {})
  }))
  default = {}
}

variable "dashboard_name" {
  type    = string
  default = null
}

variable "dashboard_body" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
