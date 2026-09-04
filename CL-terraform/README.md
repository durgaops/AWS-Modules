# CL-terraform — Standard Root Modules Library

**Audience:** Cloud COE, Platform, Project teams  
**Model:** Modules-only (no Composition, no Blueprint layers)  
**Goal:** One secured Global Modules repo that every project reuses the same way

---

## Standard flow (org-wide)

```
Cloud Center of Excellence
            │
            ▼
┌───────────────────────────────────┐
│  GLOBAL REPO (this library)       │
│  CL-terraform / Root Modules      │
│  Write: Cloud COE only            │
│  Read:  all project teams / CI    │
└────────────────┬──────────────────┘
                 │  git source + version tag (v1.x.x)
     ┌───────────┼───────────┐
     ▼           ▼           ▼
 Project-A   Project-B   Project-C     ← each project repo
 Dev/Test/Prod tfvars                  ← values only
     │           │           │
     └───────────┼───────────┘
                 ▼
        Pipeline + OIDC
                 ▼
        Target AWS Account (dev / test / prod)
```

### Layers we use

| Layer | Where | Purpose |
|-------|--------|---------|
| **Root Module** | `CL-terraform/Root Modules/<domain>/<name>` | Reusable AWS building block |
| **Project Root** | Project repo `main.tf` | Wires needed modules for that app |
| **Environment** | Project `environments/*.tfvars` | CIDRs, sizes, names, tags |
| **Target Account** | Pipeline / account map | Which AWS account receives apply |

### Layers we do **not** use

- Composition  
- Blueprint  

Those names are intentionally out of this standard to avoid confusion.

---

## Layout

```
CL-terraform/
├── README.md                          ← this file (standard flow)
├── Root Modules/                      ← reusable modules (COE-owned)
│   ├── foundation/
│   ├── identity/
│   ├── networking/
│   ├── security/
│   ├── compute/
│   ├── database/
│   ├── storage/
│   └── operations/
└── project-template/                  ← copy pattern for new project repos
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── backends/
    └── environments/
```

Full module catalog: **[Root Modules/README.md](./Root%20Modules/README.md)**  
New project starter: **[project-template/](./project-template/)**

---

## How a project consumes modules

1. Create / use a **project infra repo** (or copy `project-template/`).
2. In project `main.tf`, call Root Modules with a **pinned version**:

```hcl
module "vpc" {
  source = "git::https://github.com/<org>/<root-modules-repo>.git//CL-terraform/Root%20Modules/networking/vpc?ref=v1.0.0"

  name       = var.name_prefix
  cidr_block = var.vpc_cidr
  tags       = var.tags
}
```

3. Put env-specific values only in tfvars (`dev` / `test` / `prod`).
4. Pipeline runs plan/apply with the matching tfvars into the **target account**.

Same project `main.tf` for all environments — only tfvars + backend + account change.

---

## Hard rules (non-negotiable)

1. Root Modules have **no environment awareness** (no hardcoded `dev`/`prod`).
2. Projects **never copy** module code — only git `source` + `ref` tag.
3. **Write access** to this library is Cloud COE only (least privilege).
4. Project teams have **Read** (or CI read) on the modules repo; they write only in their project repo.
5. Promote module **code** via version tags; promote **config** via tfvars.
6. One Terraform **state** per project × environment × account.
7. Prefer `?ref=vX.Y.Z` in test/prod — avoid `ref=main` for production.

---

## Ownership

| What | Owner |
|------|--------|
| Root Modules code & releases | Cloud COE |
| Project `main.tf` wiring | Project / Platform team |
| Env tfvars & account targeting | Project + Platform / CloudOps |
| AWS apply roles (OIDC) | Platform / Security |

---

## New project checklist

1. Copy `project-template/` into a new project infra repo.  
2. Replace placeholder git URL / org name.  
3. Fill `environments/dev.tfvars` (then test/prod).  
4. Configure backend keys per env.  
5. Point pipeline at the correct AWS account per env.  
6. Plan → apply in **dev** first.
