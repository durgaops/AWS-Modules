# Required service-linked-role governance baseline (Cloud Platform).

# Creates only the SLRs explicitly requested. AWS auto-creates many SLRs;
# this module tracks required SLRs for auditability / baseline compliance.

resource "aws_iam_service_linked_role" "this" {
  for_each = { for s in var.service_linked_roles : s.aws_service_name => s }

  aws_service_name = each.value.aws_service_name
  description      = try(each.value.description, "Baseline SLR managed by Terraform")
  custom_suffix    = try(each.value.custom_suffix, null)
  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Module    = "identity/service-linked-role-baseline"
    Owner     = coalesce(var.owner, "Cloud Platform")
  })
}
