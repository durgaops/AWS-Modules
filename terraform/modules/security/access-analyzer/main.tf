# External and unused-access analysis (Security ownership).
# Complements identity/access-analyzer; this module is the security-tooling variant.

resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = var.analyzer_name
  type          = var.analyzer_type
  tags = merge(var.tags, {
    Name      = var.analyzer_name
    ManagedBy = "terraform"
    Module    = "security/access-analyzer"
    Owner     = "Security"
  })
}

resource "aws_accessanalyzer_analyzer" "unused_access" {
  count         = var.enable_unused_access_analyzer ? 1 : 0
  analyzer_name = var.unused_access_analyzer_name
  type          = var.unused_access_analyzer_type

  configuration {
    unused_access {
      unused_access_age = var.unused_access_age
    }
  }

  tags = merge(var.tags, {
    Name      = var.unused_access_analyzer_name
    ManagedBy = "terraform"
    Module    = "security/access-analyzer"
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
