# Policy-as-Code Library
#
# Policy definitions are maintained separately from infrastructure modules.
# Pipelines should pull this library and evaluate plans/code before apply.

```
terraform-policy-library/
├── checkov/                 # Checkov custom policies / .checkov.yaml
├── conftest/                # Conftest / Rego policies for Terraform plans
├── opa/                     # OPA policies (API / org controls)
├── terraform-tests/         # Terratest / terraform test suites
├── cloudformation-guard/    # AWS CloudFormation Guard rules (cfn-guard)
├── exceptions/              # Approved exceptions / waivers
└── compliance-mappings/     # Control ID → policy mappings (CIS, NIST, etc.)
```

## Suggested pipeline gate order

1. `terraform fmt` / `validate`
2. Checkov (static IaC)
3. Conftest/OPA against `tfplan.json`
4. cfn-guard (if CFN templates present)
5. Terraform tests (module contract tests)
6. Manual approval (test/prod)

## Exception handling

Store time-bound waivers under `exceptions/` with:

- control ID
- resource scope
- expiry date
- approver
- ticket / risk acceptance ID
