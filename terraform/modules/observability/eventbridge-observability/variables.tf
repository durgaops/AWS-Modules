variable "create_event_bus" {
  type    = bool
  default = false
}
variable "event_bus_name" {
  type    = string
  default = "observability"
}
variable "rules" {
  description = "List of { name, event_pattern?, schedule_expression?, targets=[{arn,...}] }"
  type        = any
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
