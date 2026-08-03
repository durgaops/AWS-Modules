# Example Terraform module contract tests placeholder
# Prefer `terraform test` (1.6+) or Terratest in CI.

# terraform {
#   required_providers {
#     aws = { source = "hashicorp/aws" }
#   }
# }
#
# run "kms_rotation_enabled" {
#   command = plan
#   module { source = "../../terraform/modules/security/kms-key" }
#   variables {
#     name = "test-key"
#   }
#   assert {
#     condition     = aws_kms_key.this.enable_key_rotation == true
#     error_message = "KMS key rotation must be enabled"
#   }
# }
