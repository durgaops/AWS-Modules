# AWS-Modules

Enterprise Terraform module library for the AWS Cloud COE.

## Start here

**[Enterprise Cloud Governance](docs/ENTERPRISE_CLOUD_GOVERNANCE.md)** — teams & duties, AWS standards, and from-scratch setup with GitHub Actions (single-repo → org).

**[Enterprise GitHub Governance](docs/ENTERPRISE_GITHUB_GOVERNANCE.md)** — org/identity, repos, rulesets, Actions, OIDC, Environments, supply chain, and audit.

**[CloudOps & DevSecOps Kickstart](docs/CLOUDOPS_DEVSECOPS_ROLES_AND_KICKSTART.md)** — roles, tasks, how each team delivers, and pre-kickoff alignment checklist.

**[Reusable Modules Guide](docs/REUSABLE_MODULES_GUIDE.md)** — full module catalog, how to reuse modules, and how to build **dev / test / prod** (and more) **without changing root module code**.

**[Terraform Structure & Usage](docs/TERRAFORM_STRUCTURE_AND_USAGE.md)** — how our layered layout works, root module vs submodules, flowcharts, and how to add a new environment or project.

**[ServiceNow → AWS Account Provisioning](docs/SERVICENOW_AWS_ACCOUNT_PROVISIONING.md)** — prerequisites, form design, approvals, and Control Tower/AFT integration so approved tickets create ready AWS accounts.

**[Guide — Maintainer rules](Guide/README.md)** — what must be updated when modules/compositions change.

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
