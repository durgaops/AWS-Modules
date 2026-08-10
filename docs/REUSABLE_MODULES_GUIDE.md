# AWS Cloud COE — Reusable Terraform Modules Guide

**Audience:** Platform engineers, application teams, and anyone consuming this library  
**Repo:** [durgaops/AWS-Modules](https://github.com/durgaops/AWS-Modules)  
**Last updated:** 2026-08-04  
**Maintainer rules:** [Guide/README.md](../Guide/README.md)  

This document is the **single source of truth** for:

1. What modules exist today  
2. How the operating model works  
3. How to **reuse** modules without changing shared root code  
4. How to stand up **dev / test / prod** (and more) safely  

> **Maintenance rule:** Any create/update/delete of a module, composition, or blueprint **must** update this guide in the same change. See **[Guide/README.md](../Guide/README.md)**.

---

## 1. Clear vision — how things work

```
┌─────────────────────────────────────────────────────────────────┐
│  modules/<domain>/*     Reusable primitives (NO env awareness) │
└───────────────────────────────┬─────────────────────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│  compositions/<domain>/*   Approved stacks of modules           │
└───────────────────────────────┬─────────────────────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│  blueprints/*              Golden paths for application teams   │
└───────────────────────────────┬─────────────────────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│  environments/<env>/*.tfvars   Values ONLY (CIDRs, sizes, tags)  │
└───────────────────────────────┬─────────────────────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│  pipelines + accounts      Plan/apply into the target account    │
└─────────────────────────────────────────────────────────────────┘
```

| Layer | Path | Who owns it | What it contains |
|-------|------|-------------|------------------|
| Modules | `terraform/modules/<domain>/` | Cloud COE / Platform | Reusable building blocks |
| Compositions | `terraform/compositions/<domain>/` | Cloud COE / Platform | Wired stacks of modules |
| Blueprints | `terraform/blueprints/` | Cloud COE (approved patterns) | End-to-end app patterns |
| Environments | `terraform/environments/<env>/` | App / Env owners | **Values only** — never new resources |
| Pipelines | `terraform/pipelines/` | Platform / DevOps | Plan/apply, gates, promotion |
| Accounts | `terraform/accounts/` | Cloud COE | Account IDs / targeting |

### Hard rules (non-negotiable)

1. **Modules have no environment awareness** — no `dev`/`prod` hardcoding, no account IDs, no region-specific business logic baked into module code.  
2. **Never edit `modules/` or `compositions/` to create a new environment** — add/change only `environments/<env>/*.tfvars` (and optionally account map / pipeline inputs).  
3. **Compositions call modules**; they do not invent unmanaged AWS resources when a module exists.  
4. **Blueprints call compositions** (preferred); call modules only when necessary.  
5. **Root legacy folders** (`modules/s3`, `modules/ec2`, `modules/kms`, `modules/iam-role`, `modules/rds`, `modules/vpc`) are **compatibility shims only** — new work must use domain paths.

---

## 2. Domains

| Domain | Modules path | Compositions path | Purpose |
|--------|--------------|-------------------|---------|
| network | `modules/network/` | `compositions/network/` | VPC, connectivity, DNS, firewall, edge |
| identity | `modules/identity/` | *(via compute/security)* | IAM, Identity Center, IRSA, OIDC |
| security | `modules/security/` | *(via storage/database)* | KMS, logging security, baselines |
| observability | `modules/observability/` | `compositions/observability/` | Logs, metrics, tracing, SIEM |
| compute | `modules/compute/` | `compositions/compute/` | EC2, ASG, LB, baselines |
| storage | `modules/storage/` | `compositions/storage/` | S3, EFS, FSx, Backup, DataSync |
| database | `modules/database/` | `compositions/database/` | RDS and related data stores |

---

## 3. Module catalog (current inventory)

### 3.1 network (`modules/network/`) — 33 modules

| Module | Purpose |
|--------|---------|
| vpc | VPC primitive |
| subnets | Public/private (and pattern) subnets |
| internet-gateway | IGW |
| egress-only-internet-gateway | IPv6 egress-only IGW |
| nat-gateway | NAT (centralized / distributed modes) |
| route-tables | Route table associations & routes |
| vpc-endpoints | Interface / gateway endpoints |
| vpc-flow-logs | Flow logs to CloudWatch / S3 |
| security-group | Reusable SG patterns |
| network-acl | NACL controls |
| transit-gateway | TGW hub |
| transit-gateway-attachment | VPC/VPN attachments |
| transit-gateway-routing | TGW route tables |
| inspection-vpc | Inspection VPC pattern |
| egress-vpc | Central egress VPC |
| ingress-vpc | Central ingress VPC |
| shared-services-vpc | Shared services VPC |
| network-firewall | AWS Network Firewall |
| firewall-manager | Firewall Manager policies |
| route53-hosted-zone | Private/public hosted zones |
| route53-resolver | Resolver endpoints / rules |
| private-dns | Private DNS composition helper |
| private-link-service | PrivateLink / endpoint service |
| ram-resource-share | RAM sharing |
| ipam | VPC IPAM pools |
| direct-connect | Direct Connect |
| site-to-site-vpn | Site-to-Site VPN |
| client-vpn | Client VPN |
| cloud-wan | Cloud WAN |
| cloudfront | CloudFront distribution baseline |
| global-accelerator | Global Accelerator |
| load-balancer | Network-edge LB pattern |
| waf | WAF Web ACL |

### 3.2 identity (`modules/identity/`) — 14 modules

| Module | Purpose |
|--------|---------|
| iam-role | Guardrailed IAM role (naming, tags, trust, boundary) |
| iam-policy | Managed / customer policy helper |
| iam-permission-boundary | Permission boundary policy |
| iam-password-account-policy | Account password policy |
| identity-center-permission-set | Identity Center permission set |
| identity-center-assignment | Permission set assignments |
| cross-account-role | Approved cross-account assume role |
| workload-identity-role | Workload role pattern |
| break-glass-role | Break-glass emergency access |
| ci-cd-oidc-role | CI/CD OIDC federation role |
| eks-irsa-role | EKS IRSA role |
| eks-pod-identity | EKS Pod Identity |
| service-linked-role-baseline | SLR baseline |
| access-analyzer | IAM Access Analyzer (identity lens) |

### 3.3 security (`modules/security/`) — 23 modules

| Module | Purpose |
|--------|---------|
| kms-key | Customer managed CMK |
| kms-multi-region-key | Multi-Region key |
| cloudtrail-organization | Org CloudTrail |
| aws-config | AWS Config recorder/delivery |
| config-aggregator | Organization aggregator |
| config-rules | Managed / custom rules |
| security-hub | Security Hub |
| guardduty | GuardDuty |
| inspector | Inspector |
| macie | Macie |
| detective | Detective |
| access-analyzer | Analyzer (security domain) |
| secrets-manager | Secrets Manager |
| parameter-store | SSM Parameter Store |
| certificate-manager | ACM certificates |
| certificate-monitoring | Expiry / event monitoring |
| security-baseline | Composed security baseline |
| compliance-baseline | Compliance-oriented baseline |
| data-protection-baseline | Encryption / protection defaults |
| resource-policy-baseline | Resource policy guards |
| event-driven-remediation | Auto-remediation patterns |
| quarantine-automation | Quarantine workflows |
| security-notifications | Security alert fan-out |

### 3.4 observability (`modules/observability/`) — 21 modules

| Module | Purpose |
|--------|---------|
| cloudwatch-log-group | Log groups |
| cloudwatch-metric-alarm | Metric alarms |
| cloudwatch-dashboard | Dashboards |
| central-log-bucket | Central immutable log bucket |
| log-subscription | Subscription filters |
| log-forwarder | SIEM / external forwarder |
| firehose-log-delivery | Firehose delivery |
| kinesis-log-streaming | Kinesis streaming |
| opensearch-logging | OpenSearch logging |
| eventbridge-observability | EventBridge rules |
| sns-notification | SNS topics |
| xray | X-Ray tracing |
| otel-collector | OpenTelemetry collector |
| managed-prometheus | AMP |
| managed-grafana | AMG |
| synthetic-monitoring | Canaries |
| rum | CloudWatch RUM |
| application-insights | Application Insights |
| service-slo | SLO / burn-rate alarms |
| incident-routing | Incident notification routing |
| observability-baseline | Composed observability baseline |

### 3.5 compute (`modules/compute/`) — 17 modules

| Module | Purpose |
|--------|---------|
| ec2-instance | Standard managed EC2 |
| ec2-launch-template | Launch templates |
| autoscaling-group | Auto Scaling |
| ec2-fleet | EC2 Fleet |
| bastion-host | Approved bastion (prefer SSM) |
| ssm-managed-instance | SSM-managed compute |
| application-load-balancer | ALB |
| network-load-balancer | NLB |
| target-group | Target groups |
| instance-profile | Instance profile |
| placement-group | Placement groups |
| linux-compute-baseline | Linux baseline |
| windows-compute-baseline | Windows baseline |
| spot-compute | Controlled Spot |
| compute-scheduler | Start/stop schedules |
| ebs-backup | Volume backup via AWS Backup |
| ec2-application-stack | Full app stack composition module |

### 3.6 storage (`modules/storage/`) — 16 modules

| Module | Purpose |
|--------|---------|
| s3-bucket | **Enterprise** S3 baseline (BPA, encryption, ownership, versioning, logging, tags, policy validation, optional replication/Object Lock/access points) |
| s3-replication | CRR / cross-account replication |
| s3-access-logging | Access logging attach pattern |
| s3-lifecycle | Retention / archival rules |
| s3-static-site | Approved private static site (+ CloudFront OAI) |
| object-lock | WORM / immutable retention |
| efs | Elastic File System |
| fsx-windows | FSx for Windows |
| fsx-lustre | FSx for Lustre |
| ebs-volume | Encrypted EBS volume |
| storage-gateway | Hybrid Storage Gateway |
| data-sync | DataSync tasks |
| backup-vault | AWS Backup vault |
| backup-plan | Backup plans & selections |
| backup-copy | Cross-account / cross-region copy helper |
| storage-baseline | Composed secure object-storage baseline |

### 3.7 database (`modules/database/`) — 1 module

| Module | Purpose |
|--------|---------|
| rds-instance | Encrypted RDS instance + DB subnet group |

### 3.8 Legacy root shims (do not use for new work)

| Shim | Prefer instead |
|------|----------------|
| `modules/s3` | `modules/storage/s3-bucket` |
| `modules/kms` | `modules/security/kms-key` |
| `modules/iam-role` | `modules/identity/iam-role` |
| `modules/ec2` | `modules/compute/ec2-instance` |
| `modules/rds` | `modules/database/rds-instance` |
| `modules/vpc` | `modules/network/*` + `compositions/network/network-foundation` |

---

## 4. Composition catalog

| Composition | Path | Wires |
|-------------|------|-------|
| network-foundation | `compositions/network/network-foundation` | vpc, subnets, igw, nat, routes, flow logs, endpoints, SG |
| network-baseline | `compositions/network/network-baseline` | Compat wrapper → network-foundation |
| enterprise-connectivity | `compositions/network/enterprise-connectivity` | TGW, inspection/shared VPCs, DX, RAM, resolver |
| compute-baseline | `compositions/compute/compute-baseline` | identity/iam-role + compute/ec2-instance |
| ec2-application-stack | `compositions/compute/ec2-application-stack` | Full EC2 app stack |
| secure-storage | `compositions/storage/secure-storage` | security/kms-key + storage/s3-bucket |
| data-tier | `compositions/database/data-tier` | security/kms-key + database/rds-instance |
| observability-baseline | `compositions/observability/observability-baseline` | Logging / metrics / tracing baseline |

---

## 5. Blueprint catalog (golden paths)

| Blueprint | Path | Uses |
|-----------|------|------|
| three-tier-webapp | `blueprints/three-tier-webapp` | network + secure-storage + compute + data-tier |
| batch-compute | `blueprints/batch-compute` | network + secure-storage + compute |
| secure-data-platform | `blueprints/secure-data-platform` | network + secure-storage + data-tier |

---

## 6. How to reuse modules (clear instructions)

### 6.1 Preferred consumption order

1. **If a blueprint exists** for your pattern → use the blueprint + environment tfvars.  
2. **Else if a composition exists** → call the composition from your root/blueprint.  
3. **Else** → call a domain module directly.

### 6.2 Call a domain module from a composition or blueprint

Use **relative paths** within this repo (current style):

```hcl
module "app_bucket" {
  source = "../../../modules/storage/s3-bucket"

  bucket_name = var.bucket_name
  kms_key_arn = var.kms_key_arn

  logging = {
    target_bucket = var.logging_bucket_id
    target_prefix = "s3-access-logs/"
  }

  tags = {
    Environment        = "dev"
    Owner              = "app-team"
    CostCenter         = "1234"
    DataClassification = "internal"
  }
}
```

From a **blueprint** (one level shallower into `modules`, but compositions sit under `compositions/<domain>/`):

```hcl
module "network" {
  source = "../../compositions/network/network-baseline"
  # ... variables ...
}
```

### 6.3 Call from an external application repo (reuse without forking root)

**Option A — Git source (recommended for app teams)**

```hcl
module "s3" {
  source = "git::https://github.com/durgaops/AWS-Modules.git//terraform/modules/storage/s3-bucket?ref=main"
  # Prefer a tag/release ref in production, e.g. ?ref=v1.2.0
  # ... inputs ...
}
```

**Option B — Compose locally against a clone**

Keep one clone of this library and point `source` at a relative/local path. Do **not** copy module code into the app repo.

### 6.4 What “without disturbing root” means

| You need… | Do this | Do **not** do this |
|-----------|---------|---------------------|
| New environment (dev/test/prod) | Add `environments/<env>/*.tfvars` | Change `modules/*` defaults to “prod sizes” |
| Different CIDRs / instance sizes | Edit only that env’s tfvars | Hardcode values into compositions |
| New application pattern | Add a blueprint under `blueprints/` | Duplicate modules into the app folder |
| One-off exceptions | Document + optional exception flags / tags | Fork the module inline and diverge forever |
| Bugfix in shared module | PR against `modules/<domain>/…` once | Patch only in your env folder |

Root / shared library stays stable. Environments are **data**, not code forks.

---

## 7. How to build and promote environments

### 7.1 Environment folders already present

```
terraform/environments/
├── shared/common.tfvars
├── dev/three-tier-webapp.tfvars
├── test/three-tier-webapp.tfvars
└── prod/three-tier-webapp.tfvars
```

Each `*.tfvars` file contains **values only** (names, CIDRs, sizes, tags). Example pattern from `dev/three-tier-webapp.tfvars`:

```hcl
name_prefix = "demo-dev"
vpc_cidr    = "10.10.0.0/16"
# ... more values ...
tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Owner       = "cloud-coe"
}
```

### 7.2 Stand up an existing blueprint in an environment

```bash
cd terraform/blueprints/three-tier-webapp

terraform init

# Plan for DEV (no code changes to modules)
terraform plan -var-file=../../environments/dev/three-tier-webapp.tfvars

# Apply DEV
terraform apply -var-file=../../environments/dev/three-tier-webapp.tfvars
```

Secrets (e.g. DB password):

```bash
# Windows PowerShell
$env:TF_VAR_db_password = "..."

# Linux/macOS
export TF_VAR_db_password='...'
```

### 7.3 Create a brand-new environment (e.g. `uat`) without touching modules

1. Create folder: `terraform/environments/uat/`  
2. Copy a tfvars template from `dev` or `test`:  
   `environments/uat/three-tier-webapp.tfvars`  
3. Change **only** values: `name_prefix`, CIDRs, sizes, bucket names, tags (`Environment = "uat"`).  
4. Update `accounts/account-map.yaml` if UAT maps to a different AWS account.  
5. Plan/apply the **same blueprint**:

```bash
cd terraform/blueprints/three-tier-webapp
terraform plan -var-file=../../environments/uat/three-tier-webapp.tfvars
```

No edits to `modules/`, `compositions/`, or blueprint logic are required.

### 7.4 Promote dev → test → prod

1. Promote **code** via Git (PR → main / release tag).  
2. Promote **config** by applying the same blueprint with the next env’s tfvars.  
3. Use separate state backends / workspaces / accounts per environment (configure in pipelines — never store env state paths inside modules).

Suggested model:

| Env | Account | State key idea | tfvars |
|-----|---------|----------------|--------|
| dev | App-Dev | `env/dev/three-tier-webapp` | `environments/dev/...` |
| test | App-Test | `env/test/three-tier-webapp` | `environments/test/...` |
| prod | App-Prod | `env/prod/three-tier-webapp` | `environments/prod/...` |

### 7.5 Build a new golden path (when no blueprint fits)

1. Prefer assembling **existing compositions**.  
2. Create `terraform/blueprints/<your-pattern>/` with `main.tf`, `variables.tf`, `outputs.tf`.  
3. Add `environments/<env>/<your-pattern>.tfvars`.  
4. Update **this guide** (blueprint catalog) in the same PR.

---

## 8. How to add or change a shared module (platform work)

Use this checklist every time:

1. Create/update under `terraform/modules/<domain>/<module-name>/`  
   - Files: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`  
   - Tags: `ManagedBy = "terraform"`, `Module = "<domain>/<module-name>"`  
2. If it belongs in a stack, wire it into `compositions/<domain>/…`.  
3. Expose via blueprint only if app teams need a golden path.  
4. **Update this document**: section 3 (catalog) and any usage examples.  
5. Update domain `modules/<domain>/README.md` if present.  
6. Do not remove required guardrails without an ADR / exception process.

---

## 9. Quick decision tree

```
Need infra in an environment?
│
├─ Pattern already a blueprint? ──► Use blueprint + environments/<env>/*.tfvars
│
├─ Need a new env for same pattern? ──► Copy tfvars; NEVER clone modules
│
├─ Need a new approved stack? ──► Add composition then blueprint
│
└─ Need a new primitive? ──► Add modules/<domain>/<name> + update THIS guide
```

---

## 10. Related docs in this repo

| Doc | Purpose |
|-----|---------|
| `Guide/README.md` | Maintainer rules (keep this catalog in sync) |
| `docs/ENTERPRISE_CLOUD_GOVERNANCE.md` | Enterprise governance, teams, AWS + GitHub Actions setup |
| `docs/TERRAFORM_STRUCTURE_AND_USAGE.md` | Layered layout, root vs submodule, new env/project flows |
| `docs/SERVICENOW_AWS_ACCOUNT_PROVISIONING.md` | ServiceNow → AWS account vending (CT + AFT) |
| `terraform/README.md` | Operating model summary |
| `terraform/OPERATING_MODEL.md` | How to start / local plan |
| `terraform/modules/README.md` | Domain map + legacy shim table |
| `terraform/compositions/README.md` | Composition layout by domain |
| `terraform/modules/<domain>/README.md` | Per-domain module lists |

---

## 11. Version history (guide)

| Date | Change |
|------|--------|
| 2026-08-10 | Linked enterprise cloud governance guide |
| 2026-08-06 | Linked Terraform structure & usage guide (root vs submodule flows) |
| 2026-08-04 | Linked ServiceNow AWS account provisioning guide |
| 2026-08-04 | Moved maintainer rules to `Guide/` (removed IDE-specific `.cursor` path from the repo) |
| 2026-08-04 | Initial guide: full inventory, reuse model, multi-env without root churn |
