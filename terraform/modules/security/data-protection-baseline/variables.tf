variable "enable_s3_account_public_access_block" {
  type    = bool
  default = true
}
variable "enable_ebs_encryption_by_default" {
  type    = bool
  default = true
}
variable "ebs_default_kms_key_arn" {
  type    = string
  default = null
}
variable "enforce_imdsv2" {
  type    = bool
  default = true
}
variable "imds_hop_limit" {
  type    = number
  default = 1
}
variable "instance_metadata_tags" {
  type    = string
  default = "disabled"
}
variable "block_public_amis" {
  type    = bool
  default = true
}
