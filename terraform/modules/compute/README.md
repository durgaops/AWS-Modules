# Compute Modules

Path: `terraform/modules/compute/`

| Module | Purpose |
|--------|---------|
| ec2-instance | Standard managed EC2 workload |
| ec2-launch-template | Secure launch templates |
| autoscaling-group | Highly available Auto Scaling |
| ec2-fleet | Fleet-based capacity |
| bastion-host | Approved bastion only (prefer SSM) |
| ssm-managed-instance | Systems Manager-managed compute |
| application-load-balancer | ALB ingress |
| network-load-balancer | NLB workloads |
| target-group | Reusable target-group config |
| ec2-application-stack | Higher-level EC2 application platform |
| windows-compute-baseline | Windows EC2 baseline |
| linux-compute-baseline | Linux EC2 baseline |
| spot-compute | Controlled Spot strategy |
| compute-scheduler | Start/stop automation |
| instance-profile | Standard EC2 IAM profile |
| placement-group | Specialized performance patterns |
| ebs-backup | AWS Backup for compute volumes |

## Recommended composition

```
ec2-application-stack
├── launch-template
├── autoscaling-group
├── load-balancer
├── target-groups
├── iam-role / instance-profile
├── cloudwatch
└── backup
```

Use:
- `modules/compute/ec2-application-stack`
- `compositions/ec2-application-stack`

## Legacy note

Prefer `modules/compute/ec2-instance` over root `modules/ec2`.
