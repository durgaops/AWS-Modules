output "workspace_arn" {
  value = aws_prometheus_workspace.this.arn
}
output "workspace_id" {
  value = aws_prometheus_workspace.this.id
}
output "prometheus_endpoint" {
  value = aws_prometheus_workspace.this.prometheus_endpoint
}
