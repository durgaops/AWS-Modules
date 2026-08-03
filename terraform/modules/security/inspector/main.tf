# Amazon Inspector vulnerability scanning (v2).

resource "aws_inspector2_enabler" "this" {
  account_ids    = var.account_ids
  resource_types = var.resource_types
}

resource "aws_inspector2_organization_configuration" "this" {
  count = var.configure_organization ? 1 : 0

  auto_enable {
    ec2         = var.auto_enable_ec2
    ecr         = var.auto_enable_ecr
    lambda      = var.auto_enable_lambda
    lambda_code = var.auto_enable_lambda_code
  }
}

resource "aws_inspector2_delegated_admin_account" "this" {
  count      = var.delegate_admin_account_id != null ? 1 : 0
  account_id = var.delegate_admin_account_id
}
