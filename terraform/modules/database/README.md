# Database Modules

Path: `terraform/modules/database/`

| Module | Purpose |
|--------|---------|
| rds-instance | Encrypted RDS instance + subnet group |

## Recommended composition

`compositions/database/data-tier` → `security/kms-key` + `database/rds-instance`

## Legacy note

Prefer `modules/database/rds-instance` over root `modules/rds`.
