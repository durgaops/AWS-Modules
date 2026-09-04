# CL-terraform — Global Infrastructure Library

**Cloud Center of Excellence** reusable Terraform modules for **any current or upcoming project**.

This folder follows the enterprise model:

```
Cloud Center of Excellence
          │
          ▼
Global Infrastructure Repository  (this library — CL-terraform)
          │
          ▼
  Versioned Terraform Modules
          │
    ┌─────┼─────┐
    ▼     ▼     ▼
 Project-A / Project-B / Project-C  (each with Dev / Test / Prod)
          │
          ▼
   Terraform Deployments → AWS
```

## Layout

```
CL-terraform/
└── Root Modules/          ← reusable library modules (no env hardcoding)
    ├── foundation/
    ├── networking/
    ├── security/
    ├── compute/
    ├── storage/
    └── operations/
```

See **[Root Modules/README.md](./Root%20Modules/README.md)** for the full module catalog and how projects consume them.

## Hard rules

1. Modules have **no environment awareness** (`dev` / `test` / `prod` live in project tfvars only).
2. Projects **reference** modules by git tag — do **not** copy module code into project repos.
3. Promote **code** via module version tags; promote **config** via env tfvars + pipeline.
4. One Terraform **state** per project × environment × account.
