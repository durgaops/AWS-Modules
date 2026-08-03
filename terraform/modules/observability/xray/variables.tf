variable "manage_encryption" {
  type    = bool
  default = true
}
variable "kms_key_arn" {
  type    = string
  default = null
}
variable "sampling_rules" {
  type    = any
  default = []
}
variable "groups" {
  type    = any
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
