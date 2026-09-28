# TCH VPC Baseline

Reusable private VPC foundation for Non-Prod and Prod. The module code stays the same. Each environment passes its own CIDRs, endpoints, routes, and tags, and uses its own Terraform state.

## Creates

- VPC
- Workload, endpoint, NLB, and Transit Gateway private subnets (one set per AZ)
- One route table per subnet tier, plus associations
- Environment-specific routes (typically a default route to an existing Transit Gateway)
- VPC Flow Logs, CloudWatch log group, and the IAM role that publishes the logs
- Hardened default security group (no allow-all rules)
- Hardened default NACL (VPC traffic plus return traffic)
- Interface and gateway VPC endpoints
- Endpoint security group for interface endpoint HTTPS access

## Project usage

```hcl
module "vpc" {
  source = "git::https://github.com/<org>/<repo>.git//CL-terraform/Root%20Modules/networking/vpc-baseline?ref=<VPC_MODULE_VERSION>"

  name     = var.vpc_name
  vpc_cidr = var.vpc_cidr

  az_subnets = {
    "us-east-1a" = {
      workload_cidr = "10.10.1.0/24"
      endpoint_cidr = "10.10.11.0/24"
      nlb_cidr      = "10.10.21.0/24"
      tgw_cidr      = "10.10.31.0/28"
    }
  }

  interface_endpoints = {
    ssm         = { service = "ssm" }
    ssmmessages = { service = "ssmmessages" }
    ec2messages = { service = "ec2messages" }
    logs        = { service = "logs" }
  }

  gateway_endpoints = {
    s3 = { service = "s3" }
  }

  endpoint_ingress_cidrs = ["10.10.1.0/24"]

  routes = {
    workload = [{
      destination_cidr_block = "0.0.0.0/0"
      transit_gateway_id     = var.transit_gateway_id
    }]
  }

  tags = var.tags
}
```

Add another AZ by adding a key to `az_subnets`. Do not change the module code.

Flow log retention defaults to 90 days. Override `flow_log_retention_days`, `flow_log_traffic_type`, and `flow_log_name` when the environment needs different logging.
