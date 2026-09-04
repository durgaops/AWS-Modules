# Root Modules — Reusable Terraform Catalog

These are **library modules** owned by the Cloud COE.  
Project repositories call them with a **versioned git source**. Environments only pass values.

## Module catalog

| Domain | Module | Path | Purpose |
|--------|--------|------|---------|
| **foundation** | aws-organizations | `foundation/aws-organizations` | Org + OUs |
| | identity-center | `foundation/identity-center` | Permission sets + account assignments |
| **networking** | vpc | `networking/vpc` | VPC primitive |
| | subnets | `networking/subnets` | Public / private / database subnets |
| | transit-gateway | `networking/transit-gateway` | TGW hub + VPC attachments |
| | route53-private-zone | `networking/route53-private-zone` | Private hosted zone + records |
| | vpc-endpoints | `networking/vpc-endpoints` | Gateway + interface endpoints |
| **security** | kms | `security/kms` | CMK + alias |
| | secrets-manager | `security/secrets-manager` | Secrets |
| | acm-private-ca | `security/acm-private-ca` | Private CA |
| | cross-account-role | `security/cross-account-role` | Cross-account IAM role |
| | security-group | `security/security-group` | SG + rules |
| **compute** | ec2 | `compute/ec2` | Managed EC2 instance |
| | nlb | `compute/nlb` | Network Load Balancer |
| **storage** | s3 | `storage/s3` | Secure S3 bucket baseline |
| **operations** | cloudwatch | `operations/cloudwatch` | Log groups, alarms, dashboard |
| | sns | `operations/sns` | Alert topic + subscriptions |
| | cloudtrail | `operations/cloudtrail` | Audit trail |
| | aws-config | `operations/aws-config` | Recorder + managed rules |
| | security-hub | `operations/security-hub` | Security Hub enablement |

Each module includes: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`.

## How a new project uses these modules

### 1. Project repo structure (recommended)

```
project-a-infra/                 ← Project-A Repo
├── main.tf                      ← calls CL-terraform modules
├── variables.tf
├── outputs.tf
├── backends/
│   ├── dev.hcl
│   ├── test.hcl
│   └── prod.hcl
└── environments/
    ├── dev.tfvars
    ├── test.tfvars
    └── prod.tfvars
```

### 2. Call a module from the project (pin a version)

```hcl
module "vpc" {
  source = "git::https://github.com/<org>/<repo>.git//CL-terraform/Root%20Modules/networking/vpc?ref=v1.0.0"

  name       = var.name_prefix
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

module "subnets" {
  source = "git::https://github.com/<org>/<repo>.git//CL-terraform/Root%20Modules/networking/subnets?ref=v1.0.0"

  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "app_ec2" {
  source = "git::https://github.com/<org>/<repo>.git//CL-terraform/Root%20Modules/compute/ec2?ref=v1.0.0"

  name                   = "${var.name_prefix}-app"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.subnets.private_subnet_ids[0]
  vpc_security_group_ids = [module.app_sg.security_group_id]
  tags                   = var.tags
}
```

> Prefer **release tags** (`v1.0.0`) in test/prod. Avoid `ref=main` for production.

### 3. Environment values only

```hcl
# environments/dev.tfvars
name_prefix   = "payments-dev"
vpc_cidr      = "10.10.0.0/16"
instance_type = "t3.medium"
tags = {
  Project     = "payments"
  Environment = "dev"
  ManagedBy   = "terraform"
}
```

Same project `main.tf` for **dev / test / prod** — only tfvars and backend change.

### 4. Deploy

```bash
cd project-a-infra
terraform init -backend-config=backends/dev.hcl
terraform plan  -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

## Ownership

| Layer | Owner | Changes |
|-------|-------|---------|
| `CL-terraform/Root Modules` | Cloud COE | Shared standards, versioned releases |
| Project repo | App / Platform team | Wiring + tfvars |
| Env tfvars / pipeline | Env owners | Sizes, CIDRs, tags, account targeting |

## Design rules

1. Do **not** hardcode account IDs, regions, or env names inside modules.
2. Do **not** copy these folders into project repos.
3. Tag resources with `Module = "<domain>/<name>"`.
4. When adding a module, update this catalog in the same change.
