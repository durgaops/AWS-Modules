# Project Template — Standard Modules-Only Flow

Copy this folder into a **new project infra repo**.  
It calls `CL-terraform/Root Modules` directly — **no Composition, no Blueprint**.

## Quick start

1. Copy `project-template/` → your `project-<name>-infra` repo root.  
2. Update git `source` URLs in `main.tf` (org / repo name).  
3. Fill `environments/dev.tfvars`.  
4. Configure `backends/*.hcl` for remote state.  
5. Run:

```bash
terraform init  -backend-config=backends/dev.hcl
terraform plan  -var-file=environments/dev.tfvars
```

## Layout

```
project-template/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── backends/
│   ├── dev.hcl
│   ├── test.hcl
│   └── prod.hcl
└── environments/
    ├── dev.tfvars
    ├── test.tfvars
    └── prod.tfvars
```
