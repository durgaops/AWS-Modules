variable "name" { type = string }
variable "description" {
  type    = string
  default = "Multi-region CMK"
}
variable "deletion_window_in_days" {
  type    = number
  default = 30
}
variable "enable_key_rotation" {
  type    = bool
  default = true
}
variable "key_policy" {
  type    = string
  default = null
}
variable "replica_key_policy" {
  type    = string
  default = null
}
variable "create_replica" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
