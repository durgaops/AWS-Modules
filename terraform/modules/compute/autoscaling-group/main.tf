# Highly available Auto Scaling group.

resource "aws_autoscaling_group" "this" {
  name                      = var.name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  target_group_arns         = var.target_group_arns
  force_delete              = var.force_delete
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  capacity_rebalance        = var.capacity_rebalance
  enabled_metrics           = var.enabled_metrics
  termination_policies      = var.termination_policies
  service_linked_role_arn   = var.service_linked_role_arn
  max_instance_lifetime     = var.max_instance_lifetime

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  dynamic "instance_refresh" {
    for_each = var.enable_instance_refresh ? [1] : []
    content {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = var.instance_refresh_min_healthy_percentage
        instance_warmup        = var.instance_refresh_warmup
      }
      triggers = var.instance_refresh_triggers
    }
  }

  dynamic "warm_pool" {
    for_each = var.warm_pool != null ? [var.warm_pool] : []
    content {
      pool_state                  = try(warm_pool.value.pool_state, "Stopped")
      min_size                    = try(warm_pool.value.min_size, 0)
      max_group_prepared_capacity = try(warm_pool.value.max_group_prepared_capacity, null)
    }
  }

  dynamic "tag" {
    for_each = merge(var.tags, { Name = var.name })
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "this" {
  for_each = { for p in var.scaling_policies : p.name => p }

  name                   = each.value.name
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = try(each.value.policy_type, "TargetTrackingScaling")
  estimated_instance_warmup = try(each.value.estimated_instance_warmup, null)

  dynamic "target_tracking_configuration" {
    for_each = try(each.value.policy_type, "TargetTrackingScaling") == "TargetTrackingScaling" ? [each.value] : []
    content {
      predefined_metric_specification {
        predefined_metric_type = try(target_tracking_configuration.value.predefined_metric_type, "ASGAverageCPUUtilization")
      }
      target_value = target_tracking_configuration.value.target_value
    }
  }
}

resource "aws_autoscaling_schedule" "this" {
  for_each = { for s in var.schedules : s.scheduled_action_name => s }

  scheduled_action_name  = each.value.scheduled_action_name
  autoscaling_group_name = aws_autoscaling_group.this.name
  min_size               = try(each.value.min_size, null)
  max_size               = try(each.value.max_size, null)
  desired_capacity       = try(each.value.desired_capacity, null)
  start_time             = try(each.value.start_time, null)
  end_time               = try(each.value.end_time, null)
  recurrence             = try(each.value.recurrence, null)
  time_zone              = try(each.value.time_zone, null)
}
