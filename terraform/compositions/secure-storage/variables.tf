variable "kms_key_name" {
  type = string
}

variable "kms_description" {
  type    = string
  default = "Secure storage CMK"
}

variable "bucket_name" {
  type = string
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
