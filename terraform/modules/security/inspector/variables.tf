variable "account_ids" {
  description = "Accounts to enable Inspector for (usually current account)"
  type        = list(string)
}
variable "resource_types" {
  type    = list(string)
  default = ["EC2", "ECR", "LAMBDA"]
}
variable "configure_organization" {
  type    = bool
  default = false
}
variable "auto_enable_ec2" {
  type    = bool
  default = true
}
variable "auto_enable_ecr" {
  type    = bool
  default = true
}
variable "auto_enable_lambda" {
  type    = bool
  default = true
}
variable "auto_enable_lambda_code" {
  type    = bool
  default = false
}
variable "delegate_admin_account_id" {
  type    = string
  default = null
}
