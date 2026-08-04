# Guide — Maintainer Rules

These rules apply to everyone updating this repository (humans and automation).

## Keep the reusable modules guide current

When you **create, rename, move, deprecate, or significantly update** anything under:

- `terraform/modules/**`
- `terraform/compositions/**`
- `terraform/blueprints/**`
- `terraform/environments/**`

you **must** update [`docs/REUSABLE_MODULES_GUIDE.md`](../docs/REUSABLE_MODULES_GUIDE.md) in the **same change**.

### Required updates in the guide

1. **Module catalog (section 3)** — add/remove/rename rows under the correct domain; keep purpose one line.
2. **Composition catalog (section 4)** — if compositions change.
3. **Blueprint catalog (section 5)** — if blueprints change.
4. **Version history (section 11)** — add a dated line summarizing the catalog change.
5. **Last updated** date at the top of the guide.

Also update the matching domain README when present:

- `terraform/modules/<domain>/README.md`
- `terraform/compositions/README.md` / `terraform/modules/README.md` if layout/domain map changes

## Non-negotiable design rules

- Modules have **no environment awareness**.
- New environments = new/updated `environments/<env>/*.tfvars` only — **do not** hardcode env values into modules or compositions.
- Prefer domain paths (`modules/storage/s3-bucket`) over legacy root shims (`modules/s3`, `modules/ec2`, etc.).
- New modules: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` + tags `ManagedBy=terraform`, `Module=<domain>/<name>`.

If the change is docs-only or unrelated to the catalog (typo in a comment, formatting), skip the guide catalog update.

## Related docs

| Doc | Purpose |
|-----|---------|
| [docs/REUSABLE_MODULES_GUIDE.md](../docs/REUSABLE_MODULES_GUIDE.md) | Full catalog + how to reuse modules / multi-env |
| [docs/SERVICENOW_AWS_ACCOUNT_PROVISIONING.md](../docs/SERVICENOW_AWS_ACCOUNT_PROVISIONING.md) | ServiceNow intake → approved AWS account ready |
| [terraform/README.md](../terraform/README.md) | Operating model summary |
| [README.md](../README.md) | Repo entry point |
