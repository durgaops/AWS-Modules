# Root Modules — Catalog & Usage

Reusable Terraform **Root Modules** for any current or upcoming project.

**Standard:** Project repos call these modules directly (version-pinned).  
**Not in scope:** Composition and Blueprint layers.

---

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

Each module has: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`.

---

## Standard consumption (project repo)

### Project layout

```
project-a-infra/
├── main.tf                 ← calls Root Modules (project root)
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

See also: [`../project-template/`](../project-template/) for a ready starter.

### Call modules with a pinned version

```hcl
module "vpc" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/networking/vpc?ref=v1.0.0"

  name       = var.name_prefix
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

module "subnets" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/networking/subnets?ref=v1.0.0"

  vpc_id          = module.vpc.vpc_id
  name_prefix     = var.name_prefix
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "app_sg" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/security/security-group?ref=v1.0.0"

  name   = "${var.name_prefix}-app-sg"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "app_ec2" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/compute/ec2?ref=v1.0.0"

  name                   = "${var.name_prefix}-app"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = module.subnets.private_subnet_ids[0]
  vpc_security_group_ids = [module.app_sg.security_group_id]
  tags                   = var.tags
}
```

Use URL-encoded path `Root%20Modules` when the folder name contains a space.

### Environment = values only

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

### Deploy into a target account

```bash
terraform init  -backend-config=backends/dev.hcl
terraform plan  -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

Pipeline selects:

| Environment | tfvars | AWS account | State key idea |
|-------------|--------|-------------|----------------|
| dev | `environments/dev.tfvars` | Dev account | `project/dev/terraform.tfstate` |
| test | `environments/test.tfvars` | Test account | `project/test/terraform.tfstate` |
| prod | `environments/prod.tfvars` | Prod account | `project/prod/terraform.tfstate` |

---

## Access model (least privilege)

| Actor | Root Modules repo | Project repo |
|-------|-------------------|--------------|
| Cloud COE | Write + release tags | Read (optional) |
| Project team | **Read only** | Write |
| CI / GitHub Actions | Contents: Read | Write as needed for PRs |

Projects never need Write on this library to reuse modules.

---

## Design rules

1. No account IDs, regions, or env names hardcoded in modules.  
2. Do not copy these folders into project repos.  
3. Tag resources with `Module = "<domain>/<name>"`.  
4. When adding/renaming a module, update this catalog in the same change.  
5. Release with semver tags (`v1.0.0`) before projects adopt in prod.
