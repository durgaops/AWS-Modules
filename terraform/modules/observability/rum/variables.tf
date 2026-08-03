variable "name" { type = string }
variable "domain" { type = string }
variable "cw_log_enabled" {
  type    = bool
  default = true
}
variable "allow_cookies" {
  type    = bool
  default = true
}
variable "enable_xray" {
  type    = bool
  default = true
}
variable "session_sample_rate" {
  type    = number
  default = 0.1
}
variable "telemetries" {
  type    = list(string)
  default = ["errors", "performance", "http"]
}
variable "guest_role_arn" {
  type    = string
  default = null
}
variable "identity_pool_id" {
  type    = string
  default = null
}
variable "excluded_pages" {
  type    = list(string)
  default = []
}
variable "included_pages" {
  type    = list(string)
  default = []
}
variable "favorite_pages" {
  type    = list(string)
  default = []
}
variable "custom_events_status" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
