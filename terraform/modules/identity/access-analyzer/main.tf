# IAM Access Analyzer configuration (Security).

resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = var.analyzer_name
  type          = var.analyzer_type
  tags = merge(var.tags, {
    Name      = var.analyzer_name
    ManagedBy = "terraform"
    Module    = "identity/access-analyzer"
    Owner     = coalesce(var.owner, "Security")
  })
}

resource "aws_accessanalyzer_archive_rule" "this" {
  for_each = { for r in var.archive_rules : r.rule_name => r }

  analyzer_name = aws_accessanalyzer_analyzer.this.id
  rule_name     = each.value.rule_name

  dynamic "filter" {
    for_each = each.value.filters
    content {
      criteria = filter.value.criteria
      contains = try(filter.value.contains, null)
      eq       = try(filter.value.eq, null)
      exists   = try(filter.value.exists, null)
      neq      = try(filter.value.neq, null)
    }
  }
}
