# Platform Compositions

Compositions are grouped by the same domains as modules:

```
compositions/
├── network/
│   ├── network-foundation
│   ├── network-baseline          # compat wrapper
│   └── enterprise-connectivity
├── compute/
│   ├── compute-baseline
│   └── ec2-application-stack
├── storage/
│   └── secure-storage
├── database/
│   └── data-tier
└── observability/
    └── observability-baseline
```

Rules:
1. Compositions call `modules/<domain>/…` only (not AWS resources when a module exists).
2. Blueprints call compositions via `compositions/<domain>/<name>`.
3. Prefer domain compositions over root legacy module paths.
