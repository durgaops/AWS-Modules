variable "bucket_id" {
  type = string
}

variable "rules" {
  type = list(object({
    id                                 = string
    enabled                            = optional(bool, true)
    prefix                             = optional(string, "")
    expiration_days                    = optional(number, null)
    noncurrent_version_expiration_days = optional(number, null)
    abort_incomplete_multipart_days    = optional(number, 7)
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
