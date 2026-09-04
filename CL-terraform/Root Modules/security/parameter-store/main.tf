# SSM Parameter Store parameters (map of parameters).

resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name            = coalesce(each.value.name, each.key)
  type            = each.value.type
  value           = each.value.value
  description     = each.value.description
  tier            = each.value.tier
  key_id          = each.value.key_id
  allowed_pattern = each.value.allowed_pattern
  data_type       = each.value.data_type

  tags = merge(var.tags, try(each.value.tags, {}), {
    Name   = coalesce(each.value.name, each.key)
    Module = "security/parameter-store"
  })
}
