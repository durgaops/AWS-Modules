# Start/stop automation via EventBridge Scheduler (or legacy CloudWatch Events).

resource "aws_iam_role" "scheduler" {
  count = var.create_scheduler_role ? 1 : 0
  name  = "${var.name_prefix}-compute-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "scheduler.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "scheduler" {
  count = var.create_scheduler_role ? 1 : 0
  name  = "${var.name_prefix}-compute-scheduler"
  role  = aws_iam_role.scheduler[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:StartInstances", "ec2:StopInstances", "ec2:DescribeInstances"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["autoscaling:UpdateAutoScalingGroup", "autoscaling:DescribeAutoScalingGroups"]
        Resource = "*"
      }
    ]
  })
}

resource "aws_scheduler_schedule" "start" {
  for_each = { for s in var.start_schedules : s.name => s }

  name                         = each.value.name
  description                  = try(each.value.description, "Start compute resources")
  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = try(each.value.timezone, "UTC")
  state                        = try(each.value.state, "ENABLED")

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = coalesce(var.scheduler_role_arn, try(aws_iam_role.scheduler[0].arn, null))
    input = jsonencode({
      InstanceIds = each.value.instance_ids
    })
  }
}

resource "aws_scheduler_schedule" "stop" {
  for_each = { for s in var.stop_schedules : s.name => s }

  name                         = each.value.name
  description                  = try(each.value.description, "Stop compute resources")
  schedule_expression          = each.value.schedule_expression
  schedule_expression_timezone = try(each.value.timezone, "UTC")
  state                        = try(each.value.state, "ENABLED")

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = coalesce(var.scheduler_role_arn, try(aws_iam_role.scheduler[0].arn, null))
    input = jsonencode({
      InstanceIds = each.value.instance_ids
    })
  }
}

resource "aws_autoscaling_schedule" "asg" {
  for_each = { for s in var.asg_schedules : s.scheduled_action_name => s }

  scheduled_action_name  = each.value.scheduled_action_name
  autoscaling_group_name = each.value.autoscaling_group_name
  min_size               = try(each.value.min_size, null)
  max_size               = try(each.value.max_size, null)
  desired_capacity       = try(each.value.desired_capacity, null)
  recurrence             = try(each.value.recurrence, null)
  time_zone              = try(each.value.time_zone, null)
  start_time             = try(each.value.start_time, null)
  end_time               = try(each.value.end_time, null)
}
