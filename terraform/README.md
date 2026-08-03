# Terraform Operating Model

```
Reusable Modules  (primitives)
       ↓
Platform Compositions
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
| 1 Reusable Modules | `modules/` | `network/*`, `identity/*`, `security/*` + compute/storage primitives |
| 2 Platform Compositions | `compositions/` | Opinionated stacks (`network-foundation`, `enterprise-connectivity`, …) |
| 3 Golden-Path Blueprints | `blueprints/` | Pre-approved application patterns for teams |
| 4 Environment Config | `environments/` | Per-env values (dev/test/prod) only — no logic |
| 5 CI/CD Pipeline | `pipelines/` | Plan/apply, policy checks, promotion gates |
| 6 AWS Accounts | `accounts/` | Account map / targeting for pipelines |

## Rules

1. **Modules** have no environment awareness (no `dev`/`prod` hardcoding).
2. **Compositions** call modules; they do not call AWS resources directly when a module exists.
3. **Blueprints** call compositions (and modules only if needed).
4. **Environments** pass variables / tfvars only — they do not define new resources.
5. **Pipelines** select blueprint + environment + target account.
