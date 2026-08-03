variable "analyzer_name" {
  type    = string
  default = "external-access"
}
variable "analyzer_type" {
  type    = string
  default = "ACCOUNT"
}
variable "enable_unused_access_analyzer" {
  type    = bool
  default = false
}
variable "unused_access_analyzer_name" {
  type    = string
  default = "unused-access"
}
variable "unused_access_analyzer_type" {
  type    = string
  default = "ACCOUNT_UNUSED_ACCESS"
}
variable "unused_access_age" {
  type    = number
  default = 90
}
variable "archive_rules" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
