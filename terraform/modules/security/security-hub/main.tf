# Central Security Hub configuration.

resource "aws_securityhub_account" "this" {
  enable_default_standards  = var.enable_default_standards
  control_finding_generator = var.control_finding_generator
  auto_enable_controls      = var.auto_enable_controls
}

resource "aws_securityhub_organization_admin_account" "this" {
  count            = var.delegate_admin_account_id != null ? 1 : 0
  admin_account_id = var.delegate_admin_account_id
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each      = toset(var.standards_arns)
  standards_arn = each.value
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_product_subscription" "this" {
  for_each    = toset(var.product_subscription_arns)
  product_arn = each.value
  depends_on  = [aws_securityhub_account.this]
}

resource "aws_securityhub_finding_aggregator" "this" {
  count            = var.enable_finding_aggregator ? 1 : 0
  linking_mode     = var.finding_aggregator_linking_mode
  specified_regions = var.finding_aggregator_linking_mode == "SPECIFIED_REGIONS" ? var.finding_aggregator_regions : null
  depends_on       = [aws_securityhub_account.this]
}
