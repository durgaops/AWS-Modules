# OpenTelemetry Collector deployment on ECS Fargate (sidecar/platform pattern).

resource "aws_ecs_task_definition" "otel" {
  count                    = var.create_ecs_collector ? 1 : 0
  family                   = var.collector_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "otel-collector"
      image     = var.collector_image
      essential = true
      command   = var.collector_command
      portMappings = [
        for p in var.ports : {
          containerPort = p
          hostPort      = p
          protocol      = "tcp"
        }
      ]
      environment = [
        for k, v in var.environment : {
          name  = k
          value = v
        }
      ]
      secrets = [
        for k, v in var.secrets : {
          name      = k
          valueFrom = v
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "otel"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name   = var.collector_name
    Module = "observability/otel-collector"
  })
}

resource "aws_ecs_service" "otel" {
  count           = var.create_ecs_collector && var.create_service ? 1 : 0
  name            = var.collector_name
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.otel[0].arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = var.assign_public_ip
  }

  tags = merge(var.tags, { Name = var.collector_name })
}

# Config content for ADOT / collector ConfigMap-style use outside ECS
locals {
  default_otel_config = var.otel_config != null ? var.otel_config : <<-YAML
    receivers:
      otlp:
        protocols:
          grpc:
          http:
    processors:
      batch:
    exporters:
      awsxray:
      awsemf:
      logging:
        loglevel: info
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [awsxray, logging]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [awsemf, logging]
  YAML
}

resource "aws_ssm_parameter" "otel_config" {
  count       = var.publish_config_to_ssm ? 1 : 0
  name        = var.config_ssm_parameter_name
  description = "OpenTelemetry Collector config"
  type        = "String"
  value       = local.default_otel_config
  tags        = var.tags
}
