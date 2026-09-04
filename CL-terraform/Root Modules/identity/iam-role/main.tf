# IAM role with managed attachments, optional inline policies, and optional instance profile.

resource "aws_iam_role" "this" {
  name                 = var.role_name
  assume_role_policy   = var.assume_role_policy
  description          = var.description
  path                 = var.path
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary_arn

  tags = merge(var.tags, {
    Name   = var.role_name
    Module = "identity/iam-role"
  })
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.role_name
  role = aws_iam_role.this.name
  path = var.path

  tags = merge(var.tags, {
    Name   = var.role_name
    Module = "identity/iam-role"
  })
}
