# SSM Parameter Store standards.

resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name        = each.key
  description = try(each.value.description, null)
  type        = try(each.value.type, "SecureString")
  value       = each.value.value
  key_id      = try(each.value.type, "SecureString") == "SecureString" ? try(each.value.kms_key_arn, var.default_kms_key_arn) : null
  tier        = try(each.value.tier, var.default_tier)
  overwrite   = try(each.value.overwrite, true)
  data_type   = try(each.value.data_type, null)
  allowed_pattern = try(each.value.allowed_pattern, null)

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name      = each.key
    ManagedBy = "terraform"
    Module    = "security/parameter-store"
  })
}
