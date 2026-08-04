# How to use this operating model

> Detailed catalog and reuse instructions: **[docs/REUSABLE_MODULES_GUIDE.md](../docs/REUSABLE_MODULES_GUIDE.md)**

## Layer flow

```
modules/<domain>/      → build & version primitives first
compositions/<domain>/ → wire primitives into platform stacks
blueprints/            → expose approved patterns to teams
environments/          → supply only values (CIDRs, sizes, tags)
pipelines/             → plan/apply against target account
accounts/              → map env → AWS account ID
```

## Domains

`network` · `identity` · `security` · `observability` · `compute` · `storage` · `database`

## Start order

1. Harden primitives under `modules/<domain>/`
2. Validate domain compositions with a sandbox `terraform plan`
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
