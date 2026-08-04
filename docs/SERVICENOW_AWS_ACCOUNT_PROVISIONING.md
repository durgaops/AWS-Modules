# ServiceNow → AWS Account Provisioning

**Audience:** Cloud COE, ServiceNow developers, Identity / Security, Platform Engineering, Product Owners  
**Purpose:** Make it clear how a product owner submits a ServiceNow request and, after manager approval, an **AWS account is ready** (provisioned, baselined, and usable)  
**Recommended AWS model:** **AWS Control Tower + Account Factory for Terraform (AFT)**  
**Optional orchestration:** COE Portal / “Scout” (or any middleware) between ServiceNow and AWS  
**Last updated:** 2026-08-04  

> **How to use references:** Every major section ends with **References** — official AWS and ServiceNow documentation. Follow those links for authoritative steps, quotas, and product behavior. Prefer family/version docs that match your ServiceNow instance release.

---

## 1. Outcome in plain language

| Step | What happens |
|------|----------------|
| 1 | Product Owner opens a **ServiceNow catalog item** and submits account details |
| 2 | Manager (and optionally Security / Cloud COE) **approve** the request |
| 3 | ServiceNow calls an **integration** (webhook / API / orchestration) |
| 4 | AWS **creates and configures** the account (Control Tower / AFT) |
| 5 | Ticket is updated with **Account ID**, login method, and next steps |
| 6 | Product Owner can use the account (SSO / Identity Center) |

**Target SLA (recommended):** Approved request → usable account within **hours**, not days (exact SLA is an org decision).

> If your organization uses a portal named **Scout** (or similar), treat it as the **orchestration layer** in the middle of ServiceNow and AWS. The business outcome is the same: **an AWS account ready for use**.

### References — Section 1

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | What is AWS Control Tower? | https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html |
| AWS | IAM Identity Center (AWS SSO) overview | https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html |
| ServiceNow | Service Catalog management | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogManagement.html |
| ServiceNow | Approvals overview | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/administer/approvals/concept/c_Approvals.html |

---

## 2. Recommended architecture (best fit for enterprise COE)

### 2.1 Why Control Tower + AFT

| Approach | When to use | Limitation |
|----------|-------------|------------|
| **Control Tower + AFT (recommended)** | Multi-account enterprise, Terraform/IaC COE, repeatable baselines | Needs CT landing zone + AFT repos/pipelines |
| Control Tower Account Factory (console/API only) | Smaller estates, less customization | Harder to version customizations in Git |
| Organizations `CreateAccount` only | Lab / non-CT orgs | No CT guardrails / Account Factory baselines by default |

**Recommendation for this COE library:**  
**ServiceNow (intake + approval) → Orchestration (optional Scout / Lambda / Step Functions) → AFT request → Control Tower enrolled account with baselines.**

### 2.2 End-to-end flow (happy path)

```
┌──────────────┐    submit     ┌─────────────────┐   approve    ┌──────────────────┐
│ Product Owner│ ───────────► │ ServiceNow RITM │ ───────────► │ Manager / CAB    │
└──────────────┘              │ + Catalog Item  │              └────────┬─────────┘
                              └────────┬────────┘                       │
                                       │ approved                       │
                                       ▼                                │
                              ┌─────────────────┐                       │
                              │ Orchestration    │◄──────────────────────┘
                              │ Scout / API GW   │
                              │ Lambda / SFNs    │
                              └────────┬────────┘
                                       │ create account request (validated JSON)
                                       ▼
                              ┌─────────────────┐
                              │ AFT (Code* +    │
                              │ CT Account      │
                              │ Factory)        │
                              └────────┬────────┘
                                       │ enroll + baseline (OU, SSO, SCP, logging…)
                                       ▼
                              ┌─────────────────┐     update ticket
                              │ New AWS Account │ ───────────────────► ServiceNow
                              │ READY           │     Account ID + SSO URL
                              └─────────────────┘
```

### 2.3 Logical components

| Layer | Component | Responsibility |
|-------|-----------|----------------|
| Intake | ServiceNow Catalog Item + Flow | Form, validation, approvals, ticket lifecycle |
| Identity | Identity Center (SSO), IdP | Who can request / who owns the account |
| Orchestration | Scout **or** API Gateway + Lambda + Step Functions | AuthN/Z, payload validation, idempotency, retries, status sync |
| Provisioning | Control Tower + AFT | Create/enroll account, OU placement, baseline customizations |
| Governance | SCPs, Config, Security Hub, CloudTrail | Guardrails after account exists |
| Feedback | ServiceNow Integration / EventBridge | Write Account ID / errors back to RITM |

### References — Section 2

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Organizing your AWS environment (multi-account) | https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html |
| AWS | AFT overview | https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html |
| AWS | Provision accounts with AFT | https://docs.aws.amazon.com/controltower/latest/userguide/taf-account-provisioning.html |
| AWS | Create an AWS account (Organizations) | https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html |
| AWS | Service control policies (SCPs) | https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html |
| AWS | Amazon EventBridge | https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html |
| AWS | API Gateway | https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html |
| AWS | AWS Lambda | https://docs.aws.amazon.com/lambda/latest/dg/welcome.html |
| AWS | AWS Step Functions | https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html |
| ServiceNow | Flow Designer | https://docs.servicenow.com/bundle/yokohama-application-development/page/administer/flow-designer/concept/flow-designer.html |
| ServiceNow | IntegrationHub | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/integrationhub/concept/c-IntegrationHub.html |

---

## 3. Prerequisites (collect these before build)

### 3.1 Organizational / people

| # | Prerequisite | Owner | Done? |
|---|--------------|-------|-------|
| 1 | Named **Cloud COE / Platform** owner for account vending | Cloud COE | ☐ |
| 2 | Named **ServiceNow** app owner / developer | ITSM | ☐ |
| 3 | Named approval chain (Manager mandatory; Security optional) | Management | ☐ |
| 4 | RACI for fail/retry/manual exception | COE + ITSM | ☐ |
| 5 | Target SLA + support model after account is ready | COE Ops | ☐ |

### 3.2 AWS landing zone

| # | Prerequisite | Notes | Done? |
|---|--------------|-------|-------|
| 1 | AWS Organizations enabled | Management account | ☐ |
| 2 | **Control Tower** landing zone deployed | Home Region decided | ☐ |
| 3 | OUs designed (e.g. Sandbox / Dev / Test / Prod / Suspended) | Map request “environment” → OU | ☐ |
| 4 | **Identity Center** integrated with corporate IdP | Permission sets for new accounts | ☐ |
| 5 | Log Archive + Audit accounts | CT standard | ☐ |
| 6 | Guardrails / SCPs baseline agreed | What applies to every new account | ☐ |
| 7 | **AFT** deployed (or decision to use Account Factory API) | Prefer AFT for IaC COE | ☐ |
| 8 | Shared Networking / DNS / CT customizations designed | Baseline VPCs optional Phase-2 | ☐ |

### 3.3 ServiceNow

| # | Prerequisite | Notes | Done? |
|---|--------------|-------|-------|
| 1 | ServiceNow instance (Dev / Test / Prod) access | Scoped app recommended | ☐ |
| 2 | App Engine / Flow Designer (or Workflow Studio) rights | Build catalog flow | ☐ |
| 3 | IntegrationHub / REST ability (or Mid Server if required) | Call AWS/orchestrator | ☐ |
| 4 | Catalog / Portal where Product Owners request services | “Cloud Account Request” | ☐ |
| 5 | Groups/roles: Requester, Approver, Cloud Fulfiller | ACLs | ☐ |
| 6 | CMDB classes if you will CIs for AWS Accounts | Optional but recommended | ☐ |

### 3.4 Integration / security

| # | Prerequisite | Notes | Done? |
|---|--------------|-------|-------|
| 1 | Connectivity SN → AWS (public HTTPS or PrivateLink/VPN) | Prefer private if mandated | ☐ |
| 2 | Auth for API calls (OAuth / IAM SigV4 / mutual TLS / API key + Secrets Manager) | Never hardcode secrets in SN | ☐ |
| 3 | Idempotency keys tied to `RITM` / `SYS_ID` | Prevents duplicate accounts | ☐ |
| 4 | Audit logging of every provisioning attempt | Both SN work notes + CloudWatch | ☐ |
| 5 | Break-glass manual provision runbook | For API outages | ☐ |

### 3.5 What you must decide up front

1. **Who is billing owner** (cost center / linked account billing)?  
2. **Environment → OU mapping** (Dev vs Prod never share OU defaults).  
3. **Account naming standard** (example: `aws-<bu>-<app>-<env>`).  
4. **Email strategy** (unique root email per account; +alias pattern).  
5. **SSO assignment** (who gets Admin / PowerUser / ReadOnly on day-1).  
6. **What “READY” means** (account enrolled only, or also VPC + landing roles).  

### References — Section 3

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Getting started with AWS Control Tower | https://docs.aws.amazon.com/controltower/latest/userguide/getting-started-with-control-tower.html |
| AWS | Plan your Control Tower landing zone | https://docs.aws.amazon.com/controltower/latest/userguide/planning-your-setup.html |
| AWS | Deploy AFT | https://docs.aws.amazon.com/controltower/latest/userguide/aft-getting-started.html |
| AWS | AFT deployment prerequisites | https://docs.aws.amazon.com/controltower/latest/userguide/aft-getting-started.html#aft-prereqs |
| AWS | Organizational units | https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html |
| AWS | AWS Secrets Manager | https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html |
| AWS | IAM security best practices | https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| ServiceNow | Application scope (scoped apps) | https://docs.servicenow.com/bundle/yokohama-application-development/page/build/applications/concept/c_ApplicationScope.html |
| ServiceNow | Configuration Management Database (CMDB) | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/configuration-management/concept/c_ConfigurationManagementDatabase.html |
| ServiceNow | Access control list rules | https://docs.servicenow.com/bundle/yokohama-platform-security/page/administer/contextual-security/concept/access-control-rules.html |
| ServiceNow | Product documentation home | https://docs.servicenow.com/ |

---

## 4. Things you need to collect (data catalog)

### 4.1 From the Product Owner (form inputs)

| Field | Required | Example | Validation |
|-------|----------|---------|------------|
| Requested by | Auto | jane.doe | From SN user profile |
| Business unit / LOB | Yes | Retail | Choice list |
| Application / Product name | Yes | payments-api | Regex / CMDB app |
| Environment | Yes | dev / test / prod / sandbox | Choice → drives OU |
| Account display name | Yes | aws-retail-payments-dev | Naming standard |
| Account email (root) | Yes | aws-retail-payments-dev@company.com | Unique, valid email |
| Cost center | Yes | CC-10422 | Finance list / regex |
| Owner (technical) | Yes | app-team-lead | Active user / group |
| Owner (business) | Yes | product-owner | Active user |
| Data classification | Yes | Internal / Confidential | Choice |
| Compliance scope | Cond. | PCI / none | Choice |
| Approximate monthly budget | Rec. | 2000 USD | Number |
| Reason / justification | Yes | Free text | Min length |
| Existing VPCs / shared services needs | No | “Need shared TGW” | Choice multi |
| Region(s) primary | Yes | us-east-1 | Allowed regions only |
| Identity Center group(s) to assign | Yes | grp-payments-dev | Group picker |
| Ticket / project reference | Rec. | JIRA-123 | Text |

### 4.2 Derived / system-populated (not typed by user)

| Data | Source |
|------|--------|
| RITM / REQ number | ServiceNow |
| Manager | User’s manager field |
| Requested OU | Map from Environment |
| SSO Permission Set(s) | Map from Environment + role |
| Tags for AWS | CostCenter, Owner, Environment, Application, DataClassification |
| Idempotency key | `sn:<ritm_number>` |
| Pipeline correlation ID | Orchestrator-generated UUID |

### 4.3 From AWS / Platform (configuration you prepare once)

| Data | Where stored |
|------|----------------|
| Allowed OUs & IDs | COE config repo / Parameter Store |
| AFT request repo URL + branch rules | AFT |
| CT Home Region | COE runbook |
| Baseline customization package version | Git tag |
| Allowed account name regex | Shared with SN client script |
| Integration API endpoint | Secrets / SN connection alias |

### 4.4 Credentials & integrations inventory

| Secret / credential | Stored in | Used by |
|---------------------|-----------|---------|
| SN → Orchestrator API client credentials | SN Connection Alias / Vault | Flow Action |
| Orchestrator → AWS role (assume role) | IAM + Secrets Manager | Lambda |
| Git token for AFT account request PR (if used) | Secrets Manager | Orchestrator |
| Webhook signing secret (SN ← AWS status) | Both sides | Status updates |

### References — Section 4

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Tagging AWS resources | https://docs.aws.amazon.com/tag-editor/latest/userguide/tagging.html |
| AWS | AWS resource tagging best practices | https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html |
| AWS | Identity Center permission sets | https://docs.aws.amazon.com/singlesignon/latest/userguide/permissionsetsconcept.html |
| AWS | Systems Manager Parameter Store | https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html |
| ServiceNow | Service Catalog variables | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogVariables.html |
| ServiceNow | Record producers / catalog items (platform) | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogManagement.html |
| ServiceNow | Connection & Credential aliases (IntegrationHub) | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/integrationhub/concept/c_ConnectionsCredentials.html |

---

## 5. How to create the ServiceNow form (step by step)

### 5.1 Design principles

1. **Collect once, validate early** — reject bad names/emails before approval.  
2. **Choices over free text** for Environment, Region, BU, Classification.  
3. **One Catalog Item** = “Request AWS Account”.  
4. **Approvals first, automation second** — never call AWS before required approvals.  
5. **Work notes** hold Account ID, OU, errors — requesters should not dig in AWS Console to learn status.

### 5.2 Step-by-step: build the Catalog Item

#### Step A — Create the Catalog Item

1. In ServiceNow, open **Service Catalog → Catalog Definitions → Maintain Items**.  
2. **New** Catalog Item:  
   - Name: `Request AWS Account`  
   - Category: `Cloud Services` (create if missing)  
   - Short description: `Provision a governed AWS account via Control Tower`  
   - Workflow / Flow: link later (Step E)  
3. Set **Availability** to your Employee Center / Service Portal.

#### Step B — Create variables (the form fields)

Create variables matching **Section 4.1**. Recommended types:

| Variable | Type |
|----------|------|
| `business_unit` | Select Box |
| `application_name` | Single Line Text |
| `environment` | Select Box (`sandbox`,`dev`,`test`,`prod`) |
| `account_name` | Single Line Text |
| `account_email` | Email |
| `cost_center` | Single Line Text (or Reference) |
| `tech_owner` | Reference → `sys_user` |
| `business_owner` | Reference → `sys_user` |
| `data_classification` | Select Box |
| `compliance_scope` | Select Box |
| `primary_region` | Select Box |
| `sso_groups` | List Collector / Reference |
| `justification` | Multi Line Text |
| `budget_usd` | Integer |

#### Step C — Client-side validation (UI Policy / Client Script)

Examples:

- `account_name` must match: `^aws-[a-z0-9]+-[a-z0-9]+-(sandbox|dev|test|prod)$`  
- `account_email` must use approved domain (`@company.com`)  
- If `environment = prod` → require Compliance attestation checkbox  
- If `environment = sandbox` → show warning that SCP restricts production-like spend  

#### Step D — Server-side validation (before insert / Script Include)

- Reject duplicate open RITMs with same `account_name` or `account_email`  
- Reject emails already used in AWS (optional API lookup to orchestration “pre-check”)  
- Normalize strings to lowercase  

#### Step E — Flow Designer / Workflow (approval + fulfill)

Recommended Flow:

1. **Trigger:** Service Catalog Item requested  
2. **Action:** Create/Update RITM work note “Submitted”  
3. **Ask for Approval:** Manager of `requested_for`  
4. *(Optional)* **Ask for Approval:** Cloud COE group (prod or high classification only)  
5. **If rejected:** Close incomplete; notify requester  
6. **If approved:**  
   - Set state = `Fulfillment` / `Provisioning`  
   - Call **Integration Action** `ProvisionAWSAccount` with JSON payload  
7. **Wait** for async callback *or* poll status endpoint (prefer callback)  
8. **On success:**  
   - Write Account ID, SSO URL, OU into work notes / variables  
   - Optionally create CMDB CI  
   - Close RITM Complete  
9. **On failure:**  
   - State = `Pending - Platform`  
   - Assign to Cloud COE assignment group  
   - Include correlation ID for debugging  

#### Step F — ACLs & notifications

- Requesters can read their RITM; cannot edit AWS Account ID after set  
- Notify requester on Submit / Approve / Reject / Ready / Failed  
- Notify Cloud COE on Failed / Manual exception  

#### Step G — Test the form in ServiceNow Dev

Use non-production ServiceNow + non-production orchestration first.

### References — Section 5

| Vendor | Topic | Link |
|--------|-------|------|
| ServiceNow | Create a catalog item | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/task/t_CreateACatalogItem.html |
| ServiceNow | Service Catalog variables | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogVariables.html |
| ServiceNow | UI Policies | https://docs.servicenow.com/bundle/yokohama-platform-administration/page/administer/form-administration/concept/c_UIPolicies.html |
| ServiceNow | Client scripts | https://docs.servicenow.com/bundle/yokohama-application-development/page/script/client-scripts/concept/client-scripts.html |
| ServiceNow | Flow Designer | https://docs.servicenow.com/bundle/yokohama-application-development/page/administer/flow-designer/concept/flow-designer.html |
| ServiceNow | Ask for Approval flow logic | https://docs.servicenow.com/bundle/yokohama-application-development/page/administer/flow-designer/reference/flow-logic-ask-for-approval.html |
| ServiceNow | Notifications | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/administer/notification/concept/c_Notification.html |
| ServiceNow | Script Includes | https://docs.servicenow.com/bundle/yokohama-api-reference/page/script/server-scripting/concept/c_ScriptIncludes.html |
| AWS | Control Tower limits and quotas (plan naming/capacity) | https://docs.aws.amazon.com/controltower/latest/userguide/limits.html |

---

## 6. Integration design (ServiceNow ↔ AWS)

### 6.1 Payload contract (approved request → orchestrator)

Minimal JSON example:

```json
{
  "idempotency_key": "sn:RITM0048123",
  "servicenow": {
    "ritm": "RITM0048123",
    "req": "REQ0012345",
    "sys_id": "a1b2c3d4e5f6...",
    "requested_for": "jane.doe@company.com",
    "callback_url": "https://company.service-now.com/api/x_coe/aws_account/status"
  },
  "account": {
    "name": "aws-retail-payments-dev",
    "email": "aws-retail-payments-dev@company.com",
    "environment": "dev",
    "ou_path": "Root/Workloads/Dev",
    "primary_region": "us-east-1"
  },
  "ownership": {
    "business_unit": "Retail",
    "application": "payments-api",
    "cost_center": "CC-10422",
    "tech_owner": "jane.doe@company.com",
    "business_owner": "product.owner@company.com",
    "data_classification": "Internal"
  },
  "access": {
    "identity_center_groups": ["grp-payments-dev"],
    "permission_set": "AWSPowerUserAccess"
  },
  "tags": {
    "Environment": "dev",
    "Owner": "jane.doe",
    "CostCenter": "CC-10422",
    "Application": "payments-api",
    "ManagedBy": "aft-servicenow"
  }
}
```

### 6.2 Orchestration options

#### Option A — Direct to AFT (simple)

ServiceNow → API Gateway → Lambda:

1. Validate payload + auth  
2. Open PR / commit AFT **account request** file (or call your approved AFT entrypoint)  
3. AFT pipeline creates/enrolls account  
4. EventBridge rule on “account ready” → Lambda → ServiceNow callback  

#### Option B — Scout / COE Portal in the middle (recommended if Scout exists)

ServiceNow → **Scout API** → Scout validates, stores request, shows status to COE → Scout triggers AFT → Scout/AWS callback → ServiceNow  

Benefits: human visibility, rich status UI, retries, manual replay without reopening ticket.

#### Option C — Step Functions state machine (highly controlled)

API Gateway → Step Functions:

`Validate → PreCheck → SubmitAFT → WaitForAccount → ApplyExtraBaseline → UpdateServiceNow → Notify`

Use waiters / callbacks so SN does not time out.

### 6.3 Status callback to ServiceNow

AWS/Orchestrator invokes SN inbound REST (Scripted REST API), for example:

`POST /api/x_coe/aws_account/status`

```json
{
  "ritm": "RITM0048123",
  "idempotency_key": "sn:RITM0048123",
  "status": "SUCCEEDED",
  "account_id": "123456789012",
  "sso_start_url": "https://d-xxxxxxxxxx.awsapps.com/start",
  "ou": "Root/Workloads/Dev",
  "message": "Account enrolled and baseline applied"
}
```

Scripted REST API must:

1. Authenticate caller  
2. Find RITM by number / sys_id  
3. Update variables + work notes  
4. Advance Flow (event / state change)  
5. Be idempotent (duplicate SUCCEEDED is OK)

### 6.4 Failure semantics

| Failure | System behavior | Ticket behavior |
|---------|-----------------|-----------------|
| Validation error | Do not call AFT | Reject / request info |
| AFT pipeline fail | Retry N times with backoff | Work note + assign COE |
| Duplicate idempotency key | Return previous result | No second account |
| Partial create | Follow AFT / CT recovery runbook | Hold RITM open |

### References — Section 6

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | AFT account provisioning pipeline | https://docs.aws.amazon.com/controltower/latest/userguide/aft-provisioning-framework.html |
| AWS | Provision accounts with AFT | https://docs.aws.amazon.com/controltower/latest/userguide/taf-account-provisioning.html |
| AWS | Amazon API Gateway | https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html |
| AWS | AWS Lambda | https://docs.aws.amazon.com/lambda/latest/dg/welcome.html |
| AWS | AWS Step Functions | https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html |
| AWS | Amazon EventBridge | https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html |
| AWS | Making API requests using IAM (SigV4) | https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_sigv.html |
| ServiceNow | Scripted REST APIs | https://docs.servicenow.com/bundle/yokohama-application-development/page/integrate/custom-web-services/concept/c_CustomWebServices.html |
| ServiceNow | Inbound REST API | https://docs.servicenow.com/bundle/yokohama-api-reference/page/integrate/inbound-rest/concept/c_RESTAPI.html |
| ServiceNow | REST step in Flow Designer / IntegrationHub | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/flow-designer/reference/rest-step.html |
| ServiceNow | IntegrationHub overview | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/integrationhub/concept/c-IntegrationHub.html |

---

## 7. AWS-side provisioning steps (Control Tower + AFT)

### 7.1 One-time platform setup

1. Confirm Control Tower landing zone healthy.  
2. Deploy **Account Factory for Terraform (AFT)** into the Management (or designated AFT) account.  
3. Configure AFT repos:  
   - Account Request  
   - Global Customizations  
   - Account Customizations  
   - Provisioning Customizations (optional)  
4. Define customization packages this COE already owns (networking stubs, IAM roles, security baseline hooks, logging).  
5. Map Environment values → OU IDs / OU names in a config file.  
6. Create IAM role for Orchestrator/Lambda: least privilege to push account requests / read pipeline status.  
7. Create EventBridge rules for account creation completion events (and pipeline failures).  

### 7.2 What runs for each approved ServiceNow ticket

1. Orchestrator writes an **account request** (Git PR or control API).  
2. AFT validates and invokes Account Factory / CT enrollment.  
3. Account is created/enrolled into target OU.  
4. CT / AFT baseline applies (CloudTrail aggregation, Config, Identity Center assignment hooks, mandatory roles/tags).  
5. Optional: account customization applies shared networking endpoints, default KMS aliases, etc.  
6. “READY” event fires → ServiceNow updated.

### 7.3 Definition of READY (agree and publish)

Minimum READY checklist:

- [ ] Account ID exists and is in correct OU  
- [ ] Control Tower enrollment succeeded  
- [ ] Root login mitigated (no standing root usage; CT controls applied)  
- [ ] Identity Center assignments for requested groups done (or ticket lists pending IdP sync SLA)  
- [ ] Org CloudTrail / Config visibility confirmed  
- [ ] Mandatory tags present  
- [ ] ServiceNow RITM updated with Account ID + access instructions  

Optional READY+ (Phase 2):

- [ ] Spoke VPC from network composition  
- [ ] Default observability baseline  
- [ ] Budget + anomaly detection  

### References — Section 7

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Deploy AFT | https://docs.aws.amazon.com/controltower/latest/userguide/aft-getting-started.html |
| AWS | AFT post-deployment steps | https://docs.aws.amazon.com/controltower/latest/userguide/aft-post-deployment.html |
| AWS | Provision accounts with AFT | https://docs.aws.amazon.com/controltower/latest/userguide/taf-account-provisioning.html |
| AWS | AFT account provisioning pipeline | https://docs.aws.amazon.com/controltower/latest/userguide/aft-provisioning-framework.html |
| AWS | AFT account customizations | https://docs.aws.amazon.com/controltower/latest/userguide/aft-account-customization.html |
| AWS | Official AFT Terraform module (GitHub) | https://github.com/aws-ia/terraform-aws-control_tower_account_factory |
| AWS | AFT on Terraform Registry | https://registry.terraform.io/modules/aws-ia/control_tower_account_factory/aws/latest |
| AWS | AWS CloudTrail | https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html |
| AWS | AWS Config | https://docs.aws.amazon.com/config/latest/developerguide/WhatIsConfig.html |
| AWS | Assign user access with Identity Center | https://docs.aws.amazon.com/singlesignon/latest/userguide/howtoassignusers.html |
| ServiceNow | Update records from integrations (platform pattern) | https://docs.servicenow.com/bundle/yokohama-api-reference/page/integrate/inbound-rest/concept/c_RESTAPI.html |

---

## 8. Master runbook — implement from zero (phased)

### Phase 0 — Discovery & design (1–2 weeks typical)

1. Workshop stakeholders (COE, SN, Security, Finance, IAM).  
2. Freeze naming, OU map, approval matrix, READY definition, SLA.  
3. Choose orchestration: Scout vs API Gateway+Lambda vs Step Functions.  
4. Produce threat model (forged ticket, double-create, email takeover).  
5. Write RACI + support model.

**Exit criteria:** Signed design one-pager + field catalog approved.

### Phase 1 — Prerequisites build

1. Complete Section 3 checklists.  
2. Stand up/validate CT + AFT in non-prod.  
3. Create SN scoped app + catalog draft in SN Dev.  
4. Create integration endpoints (auth, secrets, logging).  

**Exit criteria:** Manual AFT account request works; SN form renders with validations.

### Phase 2 — Wire happy path (non-prod)

1. Implement SN Flow approvals.  
2. Implement `ProvisionAWSAccount` action → Orchestrator.  
3. Implement status callback Scripted REST API.  
4. Test E2E with a sandbox account request.  
5. Automate work note updates & notifications.

**Exit criteria:** Approved SN ticket creates sandbox account without human AWS console clicks.

### Phase 3 — Hardening

1. Idempotency tests (re-send same RITM).  
2. Failure injection (bad OU, used email).  
3. Security review of roles & SN ACLs.  
4. Observability dashboards (success rate, time-to-ready).  
5. Runbooks for stuck pipelines.

**Exit criteria:** Security sign-off + on-call playbooks.

### Phase 4 — Production rollout

1. Promote SN app Dev → Test → Prod.  
2. Point orchestrator to prod AFT carefully (separate accounts!).  
3. Pilot with 2–3 friendly product teams.  
4. Train Product Owners (short How-To).  
5. Enable general catalog visibility.  

**Exit criteria:** SLA met for pilot; backlog of defects empty or accepted.

### References — Section 8

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | AWS Well-Architected Framework | https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html |
| AWS | Security Pillar – Well-Architected | https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html |
| AWS | Deploy AFT | https://docs.aws.amazon.com/controltower/latest/userguide/aft-getting-started.html |
| AWS | Operational excellence (observability patterns) | https://docs.aws.amazon.com/wellarchitected/latest/operational-excellence-pillar/welcome.html |
| ServiceNow | Application Development (scoped apps / ALM) | https://docs.servicenow.com/bundle/yokohama-application-development/page/build/applications/concept/c_ApplicationDevelopment.html |
| ServiceNow | Update Sets (promote Dev → Test → Prod) | https://docs.servicenow.com/bundle/yokohama-application-development/page/build/system-update-sets/concept/c_SystemUpdateSets.html |
| ServiceNow | ATF (Automated Test Framework) | https://docs.servicenow.com/bundle/yokohama-application-development/page/administer/auto-test-framework/concept/automated-test-framework.html |

---

## 9. Roles & responsibilities (RACI summary)

| Activity | Product Owner | Manager | ServiceNow | Cloud COE | Security |
|----------|---------------|---------|------------|-----------|----------|
| Fill request form | R | C | C | I | I |
| Approve business need | C | A/R | I | C | C (prod) |
| Maintain SN catalog/flow | I | I | A/R | C | C |
| Maintain AFT/CT baselines | I | I | I | A/R | C |
| Exception / manual provision | I | I | C | A/R | C |
| Access / SSO groups | R | C | I | A | C |

R = Responsible, A = Accountable, C = Consulted, I = Informed  

### References — Section 9

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Shared Responsibility Model | https://aws.amazon.com/compliance/shared-responsibility-model/ |
| AWS | Identity Center administrative permissions | https://docs.aws.amazon.com/singlesignon/latest/userguide/using-apps-with-admin-permission.html |
| ServiceNow | User administration | https://docs.servicenow.com/bundle/yokohama-platform-administration/page/administer/users-and-groups/concept/c_UsersAndGroups.html |
| ServiceNow | Groups and roles | https://docs.servicenow.com/bundle/yokohama-platform-administration/page/administer/roles/concept/c_Roles.html |

---

## 10. Security & compliance controls

1. **No root user daily use** — break-glass only.  
2. **Least privilege** for SN integration role.  
3. **Signed webhooks** / mutual auth on callbacks.  
4. **Immutable audit**: SN work notes + CloudTrail + pipeline logs share correlation ID.  
5. **Prod requests** require extra approval and possibly Security.  
6. **SCPs** prevent leaving OU/org, uncontrolled regions, disabling logging.  
7. Secrets never stored in Catalog scripts as plain text.  

### References — Section 10

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | IAM best practices | https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html |
| AWS | Protect the root user | https://docs.aws.amazon.com/IAM/latest/UserGuide/id_root-user.html |
| AWS | Service control policies | https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html |
| AWS | CloudTrail logging | https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html |
| AWS | Secrets Manager security best practices | https://docs.aws.amazon.com/secretsmanager/latest/userguide/best-practices.html |
| AWS | Security Hub | https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html |
| ServiceNow | Platform security | https://docs.servicenow.com/bundle/yokohama-platform-security/page/administer/security/concept/c_Security.html |
| ServiceNow | Access control rules | https://docs.servicenow.com/bundle/yokohama-platform-security/page/administer/contextual-security/concept/access-control-rules.html |
| ServiceNow | Credential security / Connection aliases | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/integrationhub/concept/c_ConnectionsCredentials.html |

---

## 11. Testing checklist

| # | Test case | Expected |
|---|-----------|----------|
| 1 | Submit with invalid account name | Client rejects |
| 2 | Manager rejects | No AWS call |
| 3 | Manager approves sandbox | Account created; ticket SUCCESS |
| 4 | Replay same RITM / idempotency key | No second account |
| 5 | Used root email | Fail with clear work note |
| 6 | AFT pipeline force-fail | Ticket goes Pending-Platform |
| 7 | Callback arrives twice | Ticket remains consistent |
| 8 | Prod path approvals | Both Manager + COE/Security |
| 9 | SSO group assignment | User can log into new account |
| 10 | CMDB CI created (if enabled) | CI linked to RITM |

### References — Section 11

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Testing IAM policies | https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html |
| AWS | AFT troubleshooting / operations (user guide ops topics) | https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html |
| ServiceNow | Automated Test Framework (ATF) | https://docs.servicenow.com/bundle/yokohama-application-development/page/administer/auto-test-framework/concept/automated-test-framework.html |
| ServiceNow | REST API Explorer (test inbound APIs) | https://docs.servicenow.com/bundle/yokohama-api-reference/page/integrate/inbound-rest/concept/c_RESTAPI.html |

---

## 12. Operational SLAs (suggested)

| Metric | Target (starter) |
|--------|------------------|
| Form validation response | Immediate |
| Manager approval wait | Business policy (e.g. 2 business days) |
| Time from approval → READY | ≤ 4 hours (sandbox/dev); ≤ 8 hours (prod) |
| Failure acknowledgment to COE | ≤ 15 minutes (alert) |
| Status transparency on ticket | Updated at each major state |

Tune to your org; publish in Service Catalog description.

### References — Section 12

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Control Tower account enrollment / factory timing expectations | https://docs.aws.amazon.com/controltower/latest/userguide/account-factory.html |
| AWS | CloudWatch alarms (ops alerts) | https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html |
| ServiceNow | Service Level Management / SLA definitions | https://docs.servicenow.com/bundle/yokohama-it-service-management/page/product/service-level-management/concept/c_ServiceLevelManagement.html |
| ServiceNow | Service Catalog item descriptions (publish expectations) | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogManagement.html |

---

## 13. What Product Owners should see (user journey)

1. Open Service Portal → **Request AWS Account**.  
2. Fill form → Submit → get REQ/RITM number.  
3. Manager receives approval task.  
4. After approval, ticket shows **Provisioning…**.  
5. On READY, work note includes:  
   - AWS Account ID  
   - Account name  
   - SSO start URL  
   - Assigned permission set / groups  
   - OU / environment  
   - Link to COE onboarding guide  
6. User signs in via Identity Center and begins work (no root email login required).

### References — Section 13

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | End-user access to AWS access portal (Identity Center) | https://docs.aws.amazon.com/singlesignon/latest/userguide/using-the-portal.html |
| AWS | User guide for IAM Identity Center | https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html |
| ServiceNow | Service Portal | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/build/service-portal/concept/c_ServicePortal.html |
| ServiceNow | Employee Center (if used) | https://docs.servicenow.com/bundle/yokohama-employee-service-management/page/product/employee-center/concept/employee-center.html |
| ServiceNow | Requested Item (RITM) concepts | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_RequestManagement.html |

---

## 14. Mapping to this Terraform modules repo

This repository supplies **what goes into accounts after vending** and landing zone primitives. It does **not** replace Control Tower account creation.

| Concern | Where it lives |
|---------|----------------|
| Account vending automation | Control Tower + AFT (+ Scout/orchestration) |
| Network baselines inside accounts | `terraform/modules/network/*`, `compositions/network/*` |
| Identity roles/patterns | `terraform/modules/identity/*` |
| Security baselines | `terraform/modules/security/*` |
| Observability baselines | `terraform/modules/observability/*` |
| Env-specific values after account exists | `terraform/environments/*` |

Typical sequence after account READY:

1. Pipeline targets the new Account ID (from SN / account map).  
2. Apply approved blueprint or composition (e.g. network-foundation + security-baseline).  
3. Use env tfvars only — do not fork modules per account.

Update `terraform/accounts/account-map.yaml` (or equivalent) when new accounts are approved for managed pipelines.

### References — Section 14

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | AFT account customizations (post-create IaC) | https://docs.aws.amazon.com/controltower/latest/userguide/aft-account-customization.html |
| AWS | Terraform AWS Provider | https://registry.terraform.io/providers/hashicorp/aws/latest/docs |
| Repo | Reusable modules guide | [REUSABLE_MODULES_GUIDE.md](./REUSABLE_MODULES_GUIDE.md) |
| Repo | Operating model | [terraform/OPERATING_MODEL.md](../terraform/OPERATING_MODEL.md) |

---

## 15. Decision: include Scout or not?

| If you… | Then… |
|---------|--------|
| Have / will build a COE portal called Scout | Put Scout as orchestration + status UI; SN stays intake/approvals |
| Do not have Scout | Use API Gateway + Lambda (+ Step Functions) as orchestration |
| Need max auditability | Prefer Step Functions + explicit state transitions |

Both paths share the same SN form + AFT provisioning backend.

### References — Section 15

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Amazon API Gateway | https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html |
| AWS | AWS Step Functions | https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html |
| AWS | Lambda function URLs / API patterns | https://docs.aws.amazon.com/lambda/latest/dg/lambda-urls.html |
| ServiceNow | IntegrationHub spokes / REST integrations | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/integrationhub/concept/c-IntegrationHub.html |

---

## 16. Deliverables checklist (project tracker)

- [ ] Architecture diagram approved  
- [ ] Field catalog + naming standard approved  
- [ ] SN Catalog Item + Flow in Dev  
- [ ] Orchestration API + IAM roles  
- [ ] AFT account-request path automated  
- [ ] Callback to SN working  
- [ ] SSO assignment path documented  
- [ ] Failure runbooks  
- [ ] Pilot completed  
- [ ] Prod catalog enabled  
- [ ] Training note for Product Owners  

### References — Section 16

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Control Tower user guide (landing index) | https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html |
| AWS | AFT overview | https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html |
| ServiceNow | Service Catalog management index | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogManagement.html |
| ServiceNow | Docs home (search your exact release family) | https://docs.servicenow.com/ |

---

## 17. Related documents (this repository)

| Doc | Purpose |
|-----|---------|
| [REUSABLE_MODULES_GUIDE.md](./REUSABLE_MODULES_GUIDE.md) | How to reuse Terraform modules after account exists |
| [Guide/README.md](../Guide/README.md) | Maintainer rules for this repo |
| [terraform/OPERATING_MODEL.md](../terraform/OPERATING_MODEL.md) | Modules → compositions → envs |

### References — Section 17

| Vendor | Topic | Link |
|--------|-------|------|
| AWS | Terraform on AWS (guidance hub) | https://aws.amazon.com/terraform/ |
| ServiceNow | Developer documentation portal | https://developer.servicenow.com/ |

---

## 18. Master reference index (bookmark this)

Use this index when you need the primary vendor pages quickly.

### AWS (primary)

| Topic | Link |
|-------|------|
| Control Tower | https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html |
| AFT overview | https://docs.aws.amazon.com/controltower/latest/userguide/aft-overview.html |
| Deploy AFT | https://docs.aws.amazon.com/controltower/latest/userguide/aft-getting-started.html |
| Provision with AFT | https://docs.aws.amazon.com/controltower/latest/userguide/taf-account-provisioning.html |
| AFT GitHub module | https://github.com/aws-ia/terraform-aws-control_tower_account_factory |
| Organizations | https://docs.aws.amazon.com/organizations/latest/userguide/orgs_introduction.html |
| Identity Center | https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html |
| SCPs | https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html |
| EventBridge | https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html |
| Multi-account strategy whitepaper | https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html |

### ServiceNow (primary)

| Topic | Link |
|-------|------|
| Docs home (pick your release) | https://docs.servicenow.com/ |
| Service Catalog | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/product/service-catalog-management/concept/c_ServiceCatalogManagement.html |
| Flow Designer | https://docs.servicenow.com/bundle/yokohama-application-development/page/administer/flow-designer/concept/flow-designer.html |
| IntegrationHub | https://docs.servicenow.com/bundle/yokohama-integrationhub/page/administer/integrationhub/concept/c-IntegrationHub.html |
| Scripted REST APIs | https://docs.servicenow.com/bundle/yokohama-application-development/page/integrate/custom-web-services/concept/c_CustomWebServices.html |
| Approvals | https://docs.servicenow.com/bundle/yokohama-servicenow-platform/page/administer/approvals/concept/c_Approvals.html |
| Developer portal | https://developer.servicenow.com/ |

> **ServiceNow note:** Bundle names (`yokohama`, `xanadu`, `washingtondc`, etc.) are release-family specific. If a link 404s, open https://docs.servicenow.com/ and search the page title, then select **your instance’s family**.

---

## 19. Document history

| Date | Change |
|------|--------|
| 2026-08-04 | Added official AWS + ServiceNow reference links at the end of each major section + master index |
| 2026-08-04 | Initial detailed ServiceNow ↔ AWS account provisioning guide (CT+AFT recommended; Scout optional) |
