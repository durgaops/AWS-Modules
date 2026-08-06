# Terraform Operating Model

> **Full catalog & how-to:** [docs/REUSABLE_MODULES_GUIDE.md](../docs/REUSABLE_MODULES_GUIDE.md)  
> **Structure / root vs submodule / new project:** [docs/TERRAFORM_STRUCTURE_AND_USAGE.md](../docs/TERRAFORM_STRUCTURE_AND_USAGE.md)  
> Read those guides for inventory, reuse patterns, and multi-environment workflow without changing shared library modules.

```
Reusable Modules  (primitives by domain)
       ↓
Platform Compositions  (by domain)
       ↓
Golden-Path Blueprints
       ↓
Environment Configuration
       ↓
CI/CD Pipeline
       ↓
AWS Accounts
```

| Layer | Path | Purpose |
|-------|------|---------|
| 1 Reusable Modules | `modules/<domain>/` | `network`, `identity`, `security`, `observability`, `compute`, `storage`, `database` |
| 2 Platform Compositions | `compositions/<domain>/` | `network/*`, `compute/*`, `storage/*`, `database/*`, `observability/*` |
| 3 Golden-Path Blueprints | `blueprints/` | Pre-approved application patterns for teams |
| 4 Environment Config | `environments/` | Per-env values (dev/test/prod) only — no logic |
| 5 CI/CD Pipeline | `pipelines/` | Plan/apply, policy checks, promotion gates |
| 6 AWS Accounts | `accounts/` | Account map / targeting for pipelines |

## Domain map

| Domain | Modules | Compositions |
|--------|---------|--------------|
| network | `modules/network/*` | `network-foundation`, `network-baseline`, `enterprise-connectivity` |
| identity | `modules/identity/*` | (used via compute / security compositions) |
| security | `modules/security/*` | (wired into storage / database compositions) |
| observability | `modules/observability/*` | `observability-baseline` |
| compute | `modules/compute/*` | `compute-baseline`, `ec2-application-stack` |
| storage | `modules/storage/*` | `secure-storage` |
| database | `modules/database/*` | `data-tier` |

## Rules

1. **Modules** have no environment awareness (no `dev`/`prod` hardcoding).
2. **Compositions** call modules; they do not call AWS resources directly when a module exists.
3. **Blueprints** call compositions (and modules only if needed).
4. **Environments** pass variables / tfvars only — they do not define new resources.
5. **Pipelines** select blueprint + environment + target account.
6. **New work** must use domain paths — never root legacy shims (`modules/s3`, `modules/ec2`, …).
