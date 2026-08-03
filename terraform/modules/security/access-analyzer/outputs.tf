output "analyzer_arn" {
  value = aws_accessanalyzer_analyzer.this.arn
}
output "unused_access_analyzer_arn" {
  value = try(aws_accessanalyzer_analyzer.unused_access[0].arn, null)
}
