variable "instance_arn" {
  type    = string
  default = null
}

variable "identity_store_id" {
  type    = string
  default = null
}

variable "assignments" {
  description = <<-EOT
    List of assignments:
    {
      principal_type     = "GROUP" | "USER"
      principal_id       = "<identity-store principal id>"
      account_ids        = ["111111111111", "222222222222"]
      permission_set_arn = "arn:aws:sso:::permissionSet/..."
    }
  EOT
  type = list(object({
    principal_type     = string
    principal_id       = string
    account_ids        = list(string)
    permission_set_arn = string
  }))
}
