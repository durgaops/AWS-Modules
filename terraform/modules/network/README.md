# Network Modules Library

Do **not** put the complete enterprise network in a single `vpc` module.
Use granular primitives, then assemble via compositions.

## Operating model

```
Reusable Network Modules
       ↓
Platform Network Compositions
       ↓
Golden-Path Blueprints / Account Networking
       ↓
Environment Configuration
       ↓
CI/CD Pipeline
       ↓
AWS Accounts
```

## Primitive modules (`terraform/modules/network/`)

| Module | Purpose |
|--------|---------|
| vpc | Standard VPC with DNS, tagging controls |
| subnets | Public, private, application, database, inspection |
| route-tables | Route tables and associations |
| internet-gateway | Controlled IGW |
| nat-gateway | Centralized or distributed NAT |
| egress-only-internet-gateway | IPv6 egress |
| vpc-flow-logs | Central flow-log publishing |
| vpc-endpoints | Gateway + Interface endpoints |
| security-group | Standardized SG definitions |
| network-acl | NACL patterns |
| transit-gateway | TGW deployment |
| transit-gateway-attachment | VPC / peering attachments |
| transit-gateway-routing | TGW RTs, assoc, propagation |
| network-firewall | AWS Network Firewall |
| firewall-manager | Central FMS policies |
| inspection-vpc | Central inspection architecture |
| egress-vpc | Centralized internet-egress VPC |
| ingress-vpc | Central ingress architecture |
| shared-services-vpc | DNS / directory / shared tooling |
| route53-hosted-zone | Public or private hosted zones |
| route53-resolver | Resolver endpoints + rules |
| private-dns | Private DNS zone patterns |
| ipam | AWS IPAM |
| direct-connect | Direct Connect |
| site-to-site-vpn | VPN connection + gateway |
| client-vpn | Controlled Client VPN |
| ram-resource-share | AWS RAM sharing |
| cloud-wan | Cloud WAN (when adopted) |
| global-accelerator | Global ingress acceleration |
| cloudfront | Edge delivery |
| waf | WAF Web ACL |
| load-balancer | ALB/NLB |
| private-link-service | Provider/consumer PrivateLink |

## Recommended compositions

### `compositions/network-foundation`
```
network-foundation
├── vpc
├── subnets
├── internet-gateway / nat-gateway   (foundation dependencies)
├── route-tables
├── flow-logs
├── endpoints
└── security-groups
```

### `compositions/enterprise-connectivity`
```
enterprise-connectivity
├── transit-gateway
├── tgw-routing (+ attachments)
├── inspection-vpc
├── shared-services-vpc
├── route53-resolver
├── direct-connect
└── ram-resource-share (TGW share)
```

## Legacy note

`terraform/modules/vpc` (monolithic) is **legacy**. Prefer `modules/network/*` + `compositions/network-foundation`.
