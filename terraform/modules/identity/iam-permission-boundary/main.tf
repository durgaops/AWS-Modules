# Permission-boundary enforcement policy (create + optional default attach guidance).

locals {
  boundary_name = var.name_prefix != null ? "${var.name_prefix}${var.name}" : var.name

  tags = merge(
    {
      ManagedBy = "terraform"
      Module    = "identity/iam-permission-boundary"
      Owner     = coalesce(var.owner, "Security")
    },
    var.tags,
    { Name = local.boundary_name }
  )
}

resource "aws_iam_policy" "boundary" {
  name        = local.boundary_name
  path        = var.path
  description = var.description
  policy      = var.boundary_policy_document
  tags        = local.tags
}
