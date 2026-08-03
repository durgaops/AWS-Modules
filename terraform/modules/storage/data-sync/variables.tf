variable "name" { type = string }
variable "source_location_arn" { type = string }
variable "destination_location_arn" { type = string }
variable "cloudwatch_log_group_arn" { type = string; default = null }
variable "schedule_expression" { type = string; default = null }
variable "options" {
  type = object({
    verify_mode            = optional(string, "ONLY_FILES_TRANSFERRED")
    overwrite_mode         = optional(string, "ALWAYS")
    atime                  = optional(string, "BEST_EFFORT")
    mtime                  = optional(string, "PRESERVE")
    uid                    = optional(string, "NONE")
    gid                    = optional(string, "NONE")
    preserve_deleted_files = optional(string, "PRESERVE")
    preserve_devices       = optional(string, "NONE")
    posix_permissions      = optional(string, "NONE")
    bytes_per_second       = optional(number, -1)
  })
  default = {}
}
variable "tags" { type = map(string); default = {} }
