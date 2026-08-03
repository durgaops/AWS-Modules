variable "alarms" {
  description = "List of alarm definitions"
  type        = any
  default     = []
}
variable "default_alarm_actions" {
  type    = list(string)
  default = []
}
variable "default_ok_actions" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
