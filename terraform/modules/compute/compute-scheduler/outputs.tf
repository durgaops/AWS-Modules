output "start_schedule_arns" {
  value = { for k, s in aws_scheduler_schedule.start : k => s.arn }
}
output "stop_schedule_arns" {
  value = { for k, s in aws_scheduler_schedule.stop : k => s.arn }
}
output "scheduler_role_arn" {
  value = try(aws_iam_role.scheduler[0].arn, var.scheduler_role_arn)
}
