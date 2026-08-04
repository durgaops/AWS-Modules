# AWS-Modules

Enterprise Terraform module library for the AWS Cloud COE.

## Start here

**[Reusable Modules Guide](docs/REUSABLE_MODULES_GUIDE.md)** — full module catalog, how to reuse modules, and how to build **dev / test / prod** (and more) **without changing root module code**.

## Quick layout

```
terraform/
├── modules/<domain>/        # Reusable primitives
├── compositions/<domain>/   # Approved stacks
├── blueprints/              # Golden paths for teams
├── environments/<env>/      # Values only (tfvars)
├── pipelines/               # Plan/apply automation
└── accounts/                # Account targeting
```

Domains: `network` · `identity` · `security` · `observability` · `compute` · `storage` · `database`

## Local plan example

```bash
cd terraform/blueprints/three-tier-webapp
terraform init
terraform plan -var-file=../../environments/dev/three-tier-webapp.tfvars
```

See also: `terraform/README.md` and `terraform/OPERATING_MODEL.md`.
