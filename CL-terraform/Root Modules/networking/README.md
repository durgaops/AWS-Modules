# Networking Root Modules

Reusable Terraform modules for VPC foundation and connectivity.  
**Modules-only** — projects call these directly (version-pinned). No compositions or blueprints.

## Layout

```
networking/
  vpc/
  subnets/
  route-tables/
  vpc-flow-logs/
  vpc-endpoints/
  security-group/
  tgw-vpc-attachment/
  nlb/
  alb/
  route53-private-dns/
```

Also available in this domain (not shown in the foundation pattern tree above):

- `internet-gateway/` — Internet Gateway
- `nat-gateway/` — EIP + NAT Gateway
- `transit-gateway/` — TGW hub (+ optional attachments)
- `route53-private-zone/` — private hosted zone (legacy folder name; prefer `route53-private-dns/`)

Each module has: `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`  
Requirements: Terraform `>= 1.5`, AWS provider `>= 5.0`  
Tag: `Module = "networking/<name>"`

---

## VPC foundation pattern

Wire modules in this order for a typical private VPC:

1. **VPC** — create the VPC (`networking/vpc`)
2. **Private Subnets** — place workload subnets (`networking/subnets`)
3. **Flow Logs** — enable VPC Flow Logs (`networking/vpc-flow-logs`)
4. **Endpoints / PrivateLink** — gateway + interface endpoints (`networking/vpc-endpoints`)
5. **Security Groups** — control plane for ENIs / LBs (`networking/security-group`)
6. **NLB / ALB** — L4 / L7 load balancing (`networking/nlb`, `networking/alb`)
7. **TGW attachment** — attach spoke VPC to an existing TGW (`networking/tgw-vpc-attachment`)
8. **Route53 private DNS** — private hosted zone + records (`networking/route53-private-dns`)

```
VPC → Private Subnets → Flow Logs → Endpoints/PrivateLink → SG → NLB/ALB → TGW attachment → Route53 private DNS
```

Route tables (`networking/route-tables`), IGW, and NAT are composed as needed for public egress or hybrid paths.

---

## Maintenance / patching PrivateLink

Place **maintenance and patching** VPC interface endpoints (SSM, EC2 Messages, SSM Messages, and related patch services) in the **workload VPCs that host EC2**, not only in a shared hub.

That keeps patch and agent traffic local to the VPC so it does not contend with application traffic on shared paths.

Recommended interface endpoints when using `networking/vpc-endpoints` for patchable instances:

- `com.amazonaws.<region>.ssm`
- `com.amazonaws.<region>.ssmmessages`
- `com.amazonaws.<region>.ec2messages`

Gateway endpoints (S3 / DynamoDB) remain useful for private package and API access without NAT.
