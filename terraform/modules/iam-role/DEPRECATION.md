# LEGACY — prefer terraform/modules/identity/iam-role

This primitive lacks naming, trust, boundary, and tag guardrails.
New work must use `modules/identity/iam-role` or a specialized wrapper
(cross-account-role, ci-cd-oidc-role, eks-irsa-role, etc.).
