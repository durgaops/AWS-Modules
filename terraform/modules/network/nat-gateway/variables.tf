variable "enable" {
  type    = bool
  default = true
}

variable "mode" {
  description = "centralized (single NAT) or distributed (per-AZ)"
  type        = string
  default     = "centralized"

  validation {
    condition     = contains(["centralized", "distributed"], var.mode)
    error_message = "mode must be centralized or distributed."
  }
}

variable "name_prefix" {
  type = string
}

variable "public_subnet_ids" {
  description = "Map of key => public subnet id used to place NAT(s)"
  type        = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}
