variable "name" { type = string }
variable "kms_key_arn" { type = string }
variable "force_destroy" { type = bool; default = false }
variable "lock_configuration" {
  description = "Optional vault lock (WORM)"
  type = object({
    min_retention_days  = number
    max_retention_days  = optional(number, null)
    changeable_for_days = optional(number, null)
  })
  default = null
}
variable "access_policy" { type = string; default = null }
variable "tags" { type = map(string); default = {} }
