variable "topic_name" { type = string }
variable "display_name" {
  type    = string
  default = null
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "fifo_topic" {
  type    = bool
  default = false
}
variable "content_based_deduplication" {
  type    = bool
  default = true
}
variable "subscriptions" {
  type    = any
  default = []
}
variable "topic_policy" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
