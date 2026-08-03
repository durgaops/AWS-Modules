output "workspace_arn" {
  value = aws_grafana_workspace.this.arn
}
output "workspace_id" {
  value = aws_grafana_workspace.this.id
}
output "endpoint" {
  value = aws_grafana_workspace.this.endpoint
}
output "grafana_version" {
  value = aws_grafana_workspace.this.grafana_version
}
