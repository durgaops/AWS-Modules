variable "canaries" {
  description = "List of synthetics canary definitions"
  type        = any
  default     = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
