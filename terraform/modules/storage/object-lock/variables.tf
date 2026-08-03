variable "bucket_id" {
  description = "Bucket with Object Lock enabled at creation"
  type        = string
}
variable "mode" {
  type    = string
  default = "GOVERNANCE"
  validation {
    condition     = contains(["GOVERNANCE", "COMPLIANCE"], var.mode)
    error_message = "mode must be GOVERNANCE or COMPLIANCE."
  }
}
variable "days" { type = number; default = 30 }
variable "years" { type = number; default = null }
variable "tags" { type = map(string); default = {} }
