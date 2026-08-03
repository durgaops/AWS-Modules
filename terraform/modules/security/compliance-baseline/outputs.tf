output "config_rule_names" {
  value = module.config_rules.all_rule_names
}
output "evidence_pack" {
  value = local.evidence_pack
}
output "evidence_manifest_parameter" {
  value = try(aws_ssm_parameter.evidence_manifest[0].name, null)
}
