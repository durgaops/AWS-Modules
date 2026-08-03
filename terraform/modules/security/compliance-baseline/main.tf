# Config rules and evidence requirements for compliance programs.

module "config_rules" {
  source = "../config-rules"

  managed_rules = var.managed_rules
  custom_rules  = var.custom_rules
  tags          = merge(var.tags, { ComplianceFramework = var.compliance_framework })
}

module "security_hub" {
  source = "../security-hub"
  count  = var.enable_security_hub_standards ? 1 : 0

  enable_default_standards = false
  standards_arns           = var.security_hub_standards_arns
}

locals {
  evidence_pack = {
    framework           = var.compliance_framework
    required_controls   = var.required_controls
    evidence_bucket     = var.evidence_bucket_name
    retention_days      = var.evidence_retention_days
    config_rule_names   = module.config_rules.all_rule_names
    security_hub_enabled = var.enable_security_hub_standards
  }
}

resource "aws_ssm_parameter" "evidence_manifest" {
  count = var.publish_evidence_manifest ? 1 : 0

  name        = var.evidence_manifest_parameter_name
  description = "Compliance evidence requirements manifest"
  type        = "String"
  value       = jsonencode(local.evidence_pack)
  tier        = "Standard"
  tags = merge(var.tags, {
    Name      = var.evidence_manifest_parameter_name
    Module    = "security/compliance-baseline"
  })
}
