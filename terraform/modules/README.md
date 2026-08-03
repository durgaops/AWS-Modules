# Terraform Modules

All reusable primitives live under a **domain** folder:

```
modules/
├── network/         # VPC, connectivity, DNS, firewall, …
├── identity/        # IAM, Identity Center, IRSA, OIDC, …
├── security/        # KMS, Security Hub, GuardDuty, Config, …
├── observability/   # Logs, metrics, tracing, SIEM forwarders, …
├── compute/         # EC2, ASG, LB, baselines, …
├── storage/         # S3, EFS, FSx, Backup, DataSync, …
└── database/        # RDS and related data stores
```

## Legacy root shims (do not use for new work)

| Legacy path | Prefer |
|-------------|--------|
| `modules/s3` | `modules/storage/s3-bucket` |
| `modules/kms` | `modules/security/kms-key` |
| `modules/iam-role` | `modules/identity/iam-role` |
| `modules/ec2` | `modules/compute/ec2-instance` |
| `modules/rds` | `modules/database/rds-instance` |
| `modules/vpc` | `modules/network/*` + `compositions/network/network-foundation` |

Root folders above (except `vpc`) are thin compatibility shims that call the domain module.
