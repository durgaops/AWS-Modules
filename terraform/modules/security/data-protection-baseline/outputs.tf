output "s3_public_access_block_enabled" {
  value = var.enable_s3_account_public_access_block
}
output "ebs_encryption_by_default_enabled" {
  value = var.enable_ebs_encryption_by_default
}
output "imdsv2_enforced" {
  value = var.enforce_imdsv2
}
output "public_ami_sharing_blocked" {
  value = var.block_public_amis
}
