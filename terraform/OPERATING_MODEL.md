# How to use this operating model

## Layer flow

```
modules/          → build & version primitives first
compositions/     → wire primitives into platform stacks
blueprints/       → expose approved patterns to teams
environments/     → supply only values (CIDRs, sizes, tags)
pipelines/        → plan/apply against target account
accounts/         → map env → AWS account ID
```

## Start order

1. Harden primitives under `modules/` (you already have VPC, IAM, S3, KMS, EC2, RDS)
2. Validate compositions with a small `terraform plan` in a sandbox account
3. Point `environments/dev/*.tfvars` at real AMI / bucket names
4. Update `accounts/account-map.yaml` with real account IDs
5. Wire pipeline OIDC role ARNs and run `plan` for `three-tier-webapp` / `dev`

## Local plan example

```bash
cd terraform/blueprints/three-tier-webapp
terraform init
terraform plan -var-file=../../environments/dev/three-tier-webapp.tfvars
```

Pass secrets via env:

```bash
export TF_VAR_db_password='...'
```
