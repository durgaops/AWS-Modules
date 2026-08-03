# EC2 Fleet–based capacity.

resource "aws_ec2_fleet" "this" {
  type                              = var.fleet_type
  terminate_instances               = var.terminate_instances
  terminate_instances_with_expiration = var.terminate_instances_with_expiration
  replace_unhealthy_instances       = var.replace_unhealthy_instances
  excess_capacity_termination_policy = var.excess_capacity_termination_policy

  launch_template_config {
    launch_template_specification {
      launch_template_id = var.launch_template_id
      version            = var.launch_template_version
    }

    dynamic "override" {
      for_each = var.overrides
      content {
        instance_type     = try(override.value.instance_type, null)
        max_price         = try(override.value.max_price, null)
        subnet_id         = try(override.value.subnet_id, null)
        availability_zone = try(override.value.availability_zone, null)
        weighted_capacity = try(override.value.weighted_capacity, null)
        priority          = try(override.value.priority, null)
      }
    }
  }

  target_capacity_specification {
    default_target_capacity_type = var.default_target_capacity_type
    total_target_capacity        = var.total_target_capacity
    on_demand_target_capacity    = var.on_demand_target_capacity
    spot_target_capacity         = var.spot_target_capacity
  }

  dynamic "spot_options" {
    for_each = var.default_target_capacity_type == "spot" || var.spot_target_capacity > 0 ? [1] : []
    content {
      allocation_strategy            = var.spot_allocation_strategy
      instance_interruption_behavior = var.spot_interruption_behavior
      instance_pools_to_use_count    = var.spot_instance_pools_to_use_count
    }
  }

  on_demand_options {
    allocation_strategy = var.on_demand_allocation_strategy
  }

  tags = merge(var.tags, {
    Name   = var.name
    Module = "compute/ec2-fleet"
  })
}
