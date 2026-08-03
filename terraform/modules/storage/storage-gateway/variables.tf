variable "gateway_name" { type = string }
variable "gateway_timezone" { type = string; default = "GMT" }
variable "gateway_type" {
  description = "FILE_S3 | FILE_FSX_SMB | STORED | CACHED | VTL"
  type        = string
  default     = "FILE_S3"
}
variable "activation_key" { type = string }
variable "smb_active_directory_settings" {
  type = object({
    domain_name = string
    username    = string
    password    = string
  })
  default = null
}
variable "tags" { type = map(string); default = {} }
