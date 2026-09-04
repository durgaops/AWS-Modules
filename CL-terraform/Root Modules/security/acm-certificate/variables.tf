variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "validation_method" {
  description = "Certificate validation method (DNS or EMAIL)"
  type        = string
  default     = "DNS"
}

variable "key_algorithm" {
  type    = string
  default = null
}

variable "certificate_transparency_logging_preference" {
  type    = string
  default = "ENABLED"
}

variable "tags" {
  type    = map(string)
  default = {}
}
