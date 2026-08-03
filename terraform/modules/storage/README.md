# Storage Modules

Path: `terraform/modules/storage/`

| Module | Purpose |
|--------|---------|
| s3-bucket | Secure S3 bucket baseline (enterprise guardrails) |
| s3-replication | Cross-region or cross-account replication |
| s3-access-logging | Access-logging pattern |
| s3-lifecycle | Retention and archival |
| s3-static-site | Approved static-content pattern |
| efs | Elastic File System |
| fsx-windows | FSx for Windows |
| fsx-lustre | FSx for Lustre |
| ebs-volume | Standard encrypted EBS |
| storage-gateway | Hybrid Storage Gateway |
| data-sync | DataSync migration and transfer |
| backup-vault | AWS Backup vault |
| backup-plan | Backup plans and selections |
| backup-copy | Cross-account/cross-region backup |
| object-lock | WORM and immutable retention |
| storage-baseline | Composed secure object-storage baseline |

## Enterprise `s3-bucket` guardrails

Enforces:

- Block Public Access (always on)
- Encryption (SSE-KMS preferred / required when configured)
- Bucket owner enforced ownership
- Versioning
- Access logging (required when `require_access_logging=true`)
- Lifecycle support
- Required tags
- Bucket policy validation (TLS, public deny)
- Optional replication
- Optional Object Lock
- Access-point governance

## Recommended composition

```
storage-baseline / secure-storage
├── security/kms-key
├── storage/s3-bucket
├── storage/s3-access-logging
├── storage/s3-lifecycle
└── storage/backup-vault (optional)
```

Use:
- `modules/storage/s3-bucket`
- `modules/storage/storage-baseline`
- `compositions/secure-storage`

## Legacy note

Prefer `modules/storage/s3-bucket` over root `modules/s3`.
