variable "name_prefix" {
  type    = string
  default = "compute"
}
variable "create_scheduler_role" {
  type    = bool
  default = true
}
variable "scheduler_role_arn" {
  type    = string
  default = null
}
variable "start_schedules" {
  description = "List of { name, schedule_expression, instance_ids, timezone?, state? }"
  type        = any
  default     = []
}
variable "stop_schedules" {
  type    = any
  default = []
}
variable "asg_schedules" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
