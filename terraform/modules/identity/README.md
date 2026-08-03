# Identity & Access Management Modules

Path: `terraform/modules/identity/`

## Ownership map

| Module | Purpose | Primary owner |
|--------|---------|---------------|
| identity-center-permission-set | Standard Identity Center permission sets | IAM Team |
| identity-center-assignment | Group-to-account assignments | IAM Team |
| iam-role | Standard assumable IAM roles (guardrailed) | IAM / Security |
| iam-policy | Managed IAM policy creation | Security |
| iam-permission-boundary | Permission-boundary enforcement | Security |
| cross-account-role | Standard cross-account access | IAM / Cloud Platform |
| workload-identity-role | App/service workload identities | Security / Platform |
| break-glass-role | Controlled emergency access | Security |
| ci-cd-oidc-role | OIDC for GitHub/GitLab CI/CD | DevSecOps |
| eks-irsa-role | IAM Roles for Service Accounts | Kubernetes Platform |
| eks-pod-identity | EKS Pod Identity associations | Kubernetes Platform |
| service-linked-role-baseline | Required SLR governance | Cloud Platform |
| access-analyzer | IAM Access Analyzer | Security |
| iam-password-account-policy | Legacy IAM-user password policy | Security |

## `iam-role` guardrails

The generic role module enforces:

1. **Naming convention** — `name_regex` (default `^(coe|app|plat|sec|cicd|breakglass)-[a-z0-9-]+$`)
2. **Maximum session duration** — capped by `max_session_duration_ceiling` (default 4h)
3. **Approved trust principals** — `allowed_trust_principals` allow-list
4. **Required tags** — default `Environment`, `Owner`, `CostCenter`
5. **Optional permission boundary** — `require_permission_boundary = true` forces ARN
6. **Inline-policy restrictions** — disabled by default; max count when enabled
7. **Cross-account trust validation** — `allowed_trust_account_ids`
8. **Ownership / logging metadata** — `Owner`, `CostCenter`, `DataClassification`, `ManagedBy`, `Module`

Specialized modules (`cross-account-role`, `break-glass-role`, `ci-cd-oidc-role`, etc.) wrap `iam-role` so these controls are inherited.

## Preferred usage

```hcl
module "app_role" {
  source = "../../modules/identity/workload-identity-role"

  name          = "app-payments-api"
  workload_name = "payments-api"
  permissions_boundary_arn = module.boundary.permissions_boundary_arn

  tags = {
    Environment = "dev"
    Owner       = "payments-team"
    CostCenter  = "CC-1001"
  }
}
```

## Legacy note

`terraform/modules/iam-role` (root primitives) is **legacy**. Prefer `modules/identity/*`.
