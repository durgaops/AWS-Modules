variable "parameters" {
  description = "Map of SSM Parameter Store parameters to create"
  type = map(object({
    name            = optional(string)
    type            = optional(string, "SecureString")
    value           = string
    description     = optional(string)
    tier            = optional(string, "Standard")
    key_id          = optional(string)
    allowed_pattern = optional(string)
    data_type       = optional(string)
    tags            = optional(map(string), {})
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
