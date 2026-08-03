# Security & Governance Modules

Path: `terraform/modules/security/`

| Module | Purpose |
|--------|---------|
| kms-key | Standard customer-managed KMS keys |
| kms-multi-region-key | Multi-region key + replica |
| cloudtrail-organization | Organization-level CloudTrail |
| aws-config | Config recorder and delivery |
| config-aggregator | Multi-account Config aggregation |
| config-rules | Managed and custom Config rules |
| security-hub | Central Security Hub |
| guardduty | Central GuardDuty admin |
| inspector | Vulnerability scanning |
| macie | Sensitive-data discovery |
| detective | Investigation graphs |
| access-analyzer | External + unused access analysis |
| secrets-manager | Standard secret configuration |
| parameter-store | SSM Parameter Store standards |
| certificate-manager | ACM certificates |
| certificate-monitoring | Certificate expiration alerts |
| security-baseline | Combined account security baseline |
| compliance-baseline | Config rules + evidence requirements |
| event-driven-remediation | EventBridge + Lambda corrective controls |
| quarantine-automation | Resource/account quarantine triggers |
| security-notifications | Findings → SNS / SIEM / ServiceNow |
| resource-policy-baseline | Standard S3/KMS/SNS/SQS policies |
| data-protection-baseline | Encryption, retention, public-access |

## Baselines

```
security-baseline
├── data-protection-baseline
├── access-analyzer
├── guardduty
├── security-hub
├── security-notifications
└── config-rules (optional)

compliance-baseline
├── config-rules
├── security-hub standards
└── evidence manifest (SSM)
```

## Policy-as-Code (separate)

Policies live in `terraform-policy-library/` — not inside modules:

```
terraform-policy-library/
├── checkov/
├── conftest/
├── opa/
├── terraform-tests/
├── cloudformation-guard/
├── exceptions/
└── compliance-mappings/
```

## Legacy note

`terraform/modules/kms` is legacy. Prefer `modules/security/kms-key`.
`modules/identity/access-analyzer` remains for IAM-centric use; prefer
`modules/security/access-analyzer` for security tooling baselines.
