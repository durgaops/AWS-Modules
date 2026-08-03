variable "stream_name" { type = string }
variable "stream_mode" {
  type    = string
  default = "ON_DEMAND"
}
variable "shard_count" {
  type    = number
  default = 1
}
variable "retention_period" {
  type    = number
  default = 24
}
variable "kms_key_id" {
  type    = string
  default = null
}
variable "shard_level_metrics" {
  type    = list(string)
  default = []
}
variable "enhanced_consumers" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
