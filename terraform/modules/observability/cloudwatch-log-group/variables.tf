variable "name" {
  type    = string
  default = null
}
variable "name_prefix" {
  type    = string
  default = null
}
variable "retention_in_days" {
  type    = number
  default = 90
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "skip_destroy" {
  type    = bool
  default = false
}
variable "log_group_class" {
  description = "STANDARD or INFREQUENT_ACCESS"
  type        = string
  default     = "STANDARD"
}
variable "log_streams" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
