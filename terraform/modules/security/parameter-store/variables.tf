variable "parameters" {
  description = "Map of parameter name => { value, type?, description?, kms_key_arn?, tier?, tags? }"
  type        = any
}
variable "default_kms_key_arn" {
  type    = string
  default = null
}
variable "default_tier" {
  type    = string
  default = "Standard"
}
variable "tags" {
  type    = map(string)
  default = {}
}
