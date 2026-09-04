# Security Hub enablement with optional standards subscriptions.

resource "aws_securityhub_account" "this" {
  enable_default_standards  = var.enable_default_standards
  control_finding_generator = var.control_finding_generator
  auto_enable_controls      = var.auto_enable_controls
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each = toset(var.standards_arns)

  standards_arn = each.value
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_product_subscription" "this" {
  for_each = toset(var.product_arns)

  product_arn = each.value
  depends_on  = [aws_securityhub_account.this]
}
