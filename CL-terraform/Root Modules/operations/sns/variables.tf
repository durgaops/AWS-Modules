variable "name" {
  type = string
}

variable "display_name" {
  type    = string
  default = null
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "subscriptions" {
  type = list(object({
    protocol = string
    endpoint = string
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
