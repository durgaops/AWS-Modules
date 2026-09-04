variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "recovery_window_in_days" {
  type    = number
  default = 30
}

variable "secret_string" {
  type      = string
  default   = null
  sensitive = true
}

variable "secret_binary" {
  type      = string
  default   = null
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
