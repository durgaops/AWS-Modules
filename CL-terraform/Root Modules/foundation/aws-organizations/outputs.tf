output "organization_id" {
  value = try(aws_organizations_organization.this[0].id, null)
}

output "organization_arn" {
  value = try(aws_organizations_organization.this[0].arn, null)
}

output "root_id" {
  value = local.root_id
}

output "ou_ids" {
  value = { for k, v in aws_organizations_organizational_unit.this : k => v.id }
}
