# CCOE Access Requirements — AWS, Control Tower, AFT, Repos & Pipelines

**Audience:** Cloud Center of Excellence (CCOE / Cloud COE), Identity, Security, Platform, CloudOps  
**Purpose:** Define **what access CCOE needs** (and what it must **not** have day-to-day) across Management, AFT, workload accounts, Control Tower, repositories, and pipelines  
**Model:** Least privilege · IAM Identity Center (human) · OIDC / pipeline roles (machine)  
**Companion:** [CL-terraform README](./README.md) · Modules-only Root Modules library  
**Last updated:** 2026-09-15  

---

## 1. Guiding principles

| Principle | CCOE practice |
|-----------|----------------|
| **Least privilege** | Day-to-day = Read / Operate; Admin only via break-glass or CAB-approved change |
| **No standing Admin** on Prod / Master for individuals | Use time-bound elevation |
| **Separate human vs machine** | Humans → Identity Center; Pipelines → OIDC / CodePipeline roles |
| **Segregation of duties** | Module writers ≠ sole prod approvers; AFT request ≠ silent OU change |
| **Audit everything** | CloudTrail, CodeCommit/GitHub audit, pipeline logs, SSO session logs |
| **Root user** | Never for CCOE daily work; MFA + break-glass vault only |

---

## 2. Account map (where CCOE operates)

```
Management (Master)     ← Control Tower + Organizations + Identity Center admin surfaces
        │
        ├── Log Archive / Audit     ← security evidence (CCOE: Read; Security: primary)
        ├── AFT-Management          ← CodeCommit + AFT pipelines
        ├── Shared Services / Network (optional)
        │
        ├── Sandbox OU accounts
        ├── NonProd (Dev / Test) accounts
        └── Prod accounts
```

| Account type | Primary purpose | CCOE day-to-day need |
|--------------|-----------------|----------------------|
| **Management (Master)** | Control Tower, Orgs, SCPs, CT landing zone | Elevated Platform (not permanent Admin) |
| **AFT-Management** | Account Factory for Terraform repos + pipelines | Write to AFT repos + pipeline operate |
| **Log Archive / Audit** | Org trail, Config aggregator, Security Hub | **ReadOnly** (+ Security leads higher) |
| **Shared Services / Network** | TGW hub, shared DNS, endpoints | PlatformOps / Network-aligned |
| **Sandbox / NonProd** | Workload accounts | PlatformOps + troubleshooting Read/Power |
| **Prod** | Business workloads | **ReadOnly** day-to-day; elevate for incidents |

---

## 3. Recommended Identity Center permission sets for CCOE

Create (or map) these **permission sets** and assign CCOE groups to **accounts / OUs**.

| Permission set | Typical AWS policies / scope | Who in CCOE | Where assigned |
|----------------|------------------------------|-------------|----------------|
| `CCOE-ReadOnly` | `ViewOnlyAccess` + billing view (optional) | All CCOE | All accounts |
| `CCOE-PlatformOps` | Operate LZ: limited IAM read, CT read, support, SSM session (optional), no org detach | Landing Zone / Platform engineers | Master (limited), AFT-Mgmt, Shared, NonProd |
| `CCOE-NetworkOps` | TGW, VPC read/write in network account only | Network champions in CCOE | Network / Shared Services |
| `CCOE-AFT-Operator` | CodeCommit R/W on AFT repos, CodePipeline start/stop, S3 artifacts read | AFT owners | **AFT-Management only** |
| `CCOE-ModuleAdmin` | N/A in AWS — **Git write** on Root Modules repo (see §6) | Module library owners | GitHub/CodeCommit |
| `CCOE-BreakGlass-Admin` | `AdministratorAccess` time-bound | Named dual-control list | Master / Prod **on demand only** |

**Do not** give entire CCOE `AdministratorAccess` standing on Master or Prod.

### Suggested IdP / SSO groups

| Group | Permission sets | Notes |
|-------|-----------------|-------|
| `grp-ccoe-members` | `CCOE-ReadOnly` | Everyone in CCOE |
| `grp-ccoe-platform` | `CCOE-ReadOnly` + `CCOE-PlatformOps` | LZ / CT / standards |
| `grp-ccoe-aft` | `CCOE-AFT-Operator` | AFT pipeline & account request |
| `grp-ccoe-network` | `CCOE-NetworkOps` | Hub networking |
| `grp-ccoe-breakglass` | `CCOE-BreakGlass-Admin` | 2+ people, dual control, ticket required |

---

## 4. Management (Master) account & Control Tower

### 4.1 What CCOE must be able to do

| Capability | Access level | Why |
|------------|--------------|-----|
| View Control Tower dashboard / drift | Read / PlatformOps | Landing zone health |
| Create / register OUs (e.g. Sandbox) | Change via CAB + PlatformOps or break-glass | OU design ownership |
| Enable / manage CT controls on OUs | PlatformOps + Security consult | Guardrails |
| View Organizations structure | Read | Account / OU map |
| Propose SCP changes | Change via PR/CAB; apply with elevated role | Guardrails — Security co-owns |
| Identity Center: assign CCOE groups | Identity team primary; CCOE Consulted | Avoid CCOE owning all SSO |
| Account Factory (console) emergency | Break-glass only | Prefer AFT for normal vending |
| Billing / Cost Explorer (org) | Read or FinOps-linked | Showback support |

### 4.2 What CCOE should **not** have standing

| Access | Reason |
|--------|--------|
| Standing `AdministratorAccess` on Master | Blast radius too high |
| Permanent Organizations full admin for all members | OU/SCP mistakes impact entire estate |
| Root user credentials | Break-glass vault only |
| Unilateral SCP detach without CAB | Compliance / security risk |

### 4.3 Control Tower access summary

| Action | CCOE | Security | CAB |
|--------|------|----------|-----|
| View LZ / enrolled accounts | R | R | I |
| Register new OU | R (with CAB) | C | A |
| Enable preventive/detective controls | R | C/A for security controls | A for high risk |
| Repair / re-register OU | R | C | I |
| Landing zone update / repair | R | C | A |

**R** = Responsible day-to-day · **A** = Accountable approval · **C** = Consulted · **I** = Informed

---

## 5. AFT-Management account

AFT lives here (CodeCommit + CodePipeline / CodeBuild). This is **CCOE’s primary operational account** for account vending.

### 5.1 AWS IAM / SSO access in AFT-Management

| Need | Access |
|------|--------|
| Browse / edit AFT CodeCommit repos | `CCOE-AFT-Operator` (CodeCommit Git R/W on AFT repos only) |
| Start / approve / troubleshoot AFT pipelines | CodePipeline Read + StartPipelineExecution; CodeBuild Read/Retry |
| Read AFT artifacts / logs | S3 artifact bucket Read; CloudWatch Logs Read |
| View EventBridge / SNS failure topics | Read |
| Change AFT Terraform backend / state | Restricted to AFT owners + dual control |
| Create IAM users with access keys | **Denied** (use SSO + roles) |

### 5.2 AFT repository access (CodeCommit)

| Repo | CCOE access | Others |
|------|-------------|--------|
| `aft-account-request` | **Write** (platform/AFT group) | App teams: usually **no** direct write (via ServiceNow / PR by CCOE) |
| `aft-global-customizations` | **Write** (CCOE only) | Read for Security/Network as needed |
| `aft-account-customizations` | **Write** (CCOE only) | Read for reviewers |
| `aft-provisioning-customizations` | **Write** (CCOE only) | Read optional |
| AFT feature / code library (if separate) | **Write** CCOE | Read Security |

**Branch protection (even on CodeCommit):** require PR / dual review for `main` on customization repos.

### 5.3 AFT pipelines access

| Pipeline | CCOE | Security | App teams |
|----------|------|----------|-----------|
| Account provisioning | Operate (start/retry) + Read logs | Read | Informed via ticket |
| Global customizations | Operate + Write via Git | Review on PR | No |
| Account customizations | Operate + Write via Git | Review on PR | No |
| Failed pipeline deep debug | PlatformOps + CloudWatch | Consulted | No |

CCOE does **not** need Admin on AFT-Management if CodeCommit/CodePipeline/S3/CW permissions are scoped correctly.

---

## 6. Repositories (Root Modules + project repos)

Aligned with **modules-only** CL-terraform standard.

### 6.1 Global Root Modules repo (`aws-root-modules` / this library)

| Role | GitHub/CodeCommit permission | Purpose |
|------|------------------------------|---------|
| CCOE Module Owners | **Write** + merge to `main` (via PR) | Own Root Modules |
| CCOE members (broader) | Write via PR **or** Read | Contribute / review |
| Security / Architect | **Read** + required reviewers | Guardrail review |
| Project / App teams | **Read** only | Consume via `git::...?ref=vX.Y.Z` |
| CI bots (project pipelines) | **Contents: Read** | `terraform init` |

**Rulesets:** PR required, CODEOWNERS = CCOE, status checks (fmt/validate/tfsec), release tags for prod pins.

### 6.2 Project infra repos (`project-*-infra`)

| Role | Access |
|------|--------|
| App / Project team | **Write** on their project repo |
| CCOE | **Read** + optional maintain for standards PRs |
| CCOE | Can require rulesets (branch protection) via org admin partnership |

CCOE should **not** take over day-to-day tfvars ownership.

### 6.3 Landing zone / CT customization repos (if separate)

| Repo | CCOE |
|------|------|
| CT / SCP / OU as-code | Write (Platform) + CAB for apply |
| Network hub Terraform | Write with Network co-owners |

---

## 7. Workload accounts (Sandbox, NonProd, Prod)

### 7.1 Access matrix

| Account class | CCOE day-to-day | CCOE elevated | App team |
|---------------|-----------------|---------------|----------|
| **Sandbox** | PlatformOps (create baselines, fix AFT drift) | Break-glass rare | PowerUser / scoped Admin per policy |
| **Dev / Test** | ReadOnly + limited PlatformOps | Change windows | Write via pipeline + SSO as designed |
| **Prod** | **ReadOnly** | Break-glass + ticket + dual control | Pipeline apply + app SSO (least privilege) |

### 7.2 What CCOE uses access for in workload accounts

- Validate AFT / CT enrollment and baselines  
- Troubleshoot OIDC / Terraform deploy roles  
- Inspect tagging, Config, GuardDuty findings routing  
- Support incidents (with SRE)  

CCOE should **not** be the standing application Admin in Prod.

### 7.3 Machine roles CCOE must own/design (not personal Admin)

| Role | Account | Used by |
|------|---------|---------|
| `TerraformDeploy-Dev` | Dev | Project pipelines (OIDC) |
| `TerraformDeploy-Test` | Test | Project pipelines |
| `TerraformDeploy-Prod` | Prod | Project pipelines + approval gate |
| `AFTExecution` / CT roles | As per AFT | AFT (managed by framework) |
| `CCOE-BreakGlass` | Selected | Human elevation only |

CCOE designs and reviews these roles; Identity/Security approve trust policies.

---

## 8. Pipelines — full picture

### 8.1 AFT pipelines (AFT-Management)

| Need | CCOE level |
|------|------------|
| View execution history | Read |
| Retry failed account vending | Operate |
| Change pipeline definition | Write via IaC PR + dual review |
| Approve manual stages (if any) | Named CCOE + Security for prod-like |

### 8.2 Project Terraform pipelines (GitHub Actions / CodePipeline)

| Need | CCOE level |
|------|------------|
| Org reusable workflows / OIDC pattern | Own / co-own with GitHub Admin |
| Project workflow content | Read + standards enforcement |
| Prod environment approvers | Often CCOE **or** CAB delegates — not sole silent apply |
| Runner admin (if self-hosted) | Platform / GitHub Admin; CCOE Consulted |

### 8.3 Pipeline secrets & OIDC

| Item | CCOE |
|------|------|
| Create GitHub OIDC provider in AWS | PlatformOps (with Security) |
| Store long-lived AWS keys in GitHub | **Forbidden** |
| Rotate deploy roles | CCOE + Identity |
| Environment protection rules | CCOE + GitHub Admin |

---

## 9. One-page “CCOE access package” (request this from Identity)

Use this as the formal access request.

### AWS (Identity Center)

1. Group `grp-ccoe-members` → `CCOE-ReadOnly` → **all accounts**  
2. Group `grp-ccoe-platform` → `CCOE-PlatformOps` → Master (scoped), AFT-Mgmt, Shared, NonProd OUs  
3. Group `grp-ccoe-aft` → `CCOE-AFT-Operator` → **AFT-Management only**  
4. Group `grp-ccoe-network` → `CCOE-NetworkOps` → Network/Shared only  
5. Group `grp-ccoe-breakglass` → `CCOE-BreakGlass-Admin` → Master + Prod (**requestable**, not standing)  

### Control Tower

- Console access via Master SSO with PlatformOps  
- Documented CAB process for OU / control / LZ changes  

### Repos

- Root Modules repo: **Maintain/Write** for module owners; **Read** for everyone else who consumes  
- AFT CodeCommit repos: **Write** for `grp-ccoe-aft`  
- Project repos: **Read** for CCOE  

### Pipelines

- AFT: Read + Start/Retry for operators  
- Project CI: org workflow ownership; prod approval participation as defined by CAB  

---

## 10. Break-glass procedure (mandatory)

1. Incident / urgent LZ failure ticket (ServiceNow / Jira).  
2. Dual approval (CCOE Lead + Security or CAB delegate).  
3. Temporary assignment of `CCOE-BreakGlass-Admin` (time-boxed, e.g. 4 hours).  
4. All actions in Master/Prod logged; post-action review within 24–48h.  
5. Remove elevation immediately after.  

**Never** leave break-glass assigned permanently.

---

## 11. RACI — who decides access

| Decision | CCOE | Identity | Security | CAB | App team |
|----------|------|----------|----------|-----|----------|
| CCOE permission set design | R | A/R | C | I | I |
| Assign CCOE to Master elevate | C | R | C | A | I |
| AFT repo write | A/R | C | C | I | I |
| Root Modules write | A/R | I | C | I | I |
| Prod human Admin | C | R | C | A | I |
| OIDC deploy role trust | R | C | C | I | C |

---

## 12. Minimum vs elevated — quick reference

| Area | Minimum (every CCOE member) | Elevated (named roles only) |
|------|-----------------------------|-----------------------------|
| All AWS accounts | ReadOnly | — |
| Master / Control Tower | Read CT + Orgs | PlatformOps / Break-glass for changes |
| AFT-Management | Read pipelines | AFT Operator write + pipeline operate |
| Sandbox / NonProd | Read | PlatformOps troubleshoot |
| Prod | ReadOnly | Break-glass only |
| Root Modules Git | Read | Write / merge (module owners) |
| AFT Git | Read (optional) | Write (AFT owners) |
| Project Git | Read | Write only if supporting that project |
| Pipelines | Read logs | Start/retry AFT; approve prod per CAB |

---

## 13. Implementation checklist

- [ ] Create SSO groups listed in §3  
- [ ] Create permission sets (no standing Admin)  
- [ ] Assign ReadOnly org-wide for `grp-ccoe-members`  
- [ ] Scope PlatformOps / AFT / Network to correct accounts  
- [ ] Configure CodeCommit IAM for AFT repos only  
- [ ] Protect AFT + Root Modules `main` with reviews  
- [ ] Document break-glass + test annually  
- [ ] Confirm project pipelines use OIDC (no static keys)  
- [ ] Align ServiceNow account vending so app teams don’t need AFT write  

---

## 14. Document history

| Date | Change |
|------|--------|
| 2026-09-15 | Initial CCOE access requirements for AWS accounts, Control Tower, AFT, repos, and pipelines |
