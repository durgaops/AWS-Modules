variable "name" {
  type = string
}

variable "type" {
  type    = string
  default = "ROOT"
}

variable "usage_mode" {
  type    = string
  default = "GENERAL_PURPOSE"
}

variable "key_algorithm" {
  type    = string
  default = "RSA_2048"
}

variable "signing_algorithm" {
  type    = string
  default = "SHA256WITHRSA"
}

variable "subject" {
  type = object({
    common_name         = string
    organization        = optional(string)
    organizational_unit = optional(string)
    country             = optional(string)
    state               = optional(string)
    locality            = optional(string)
  })
}

variable "permanent_deletion_time_in_days" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
