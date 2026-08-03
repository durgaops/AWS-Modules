# LEGACY SHIM — prefer terraform/modules/network/* + compositions/network/network-foundation

This root module still contains the old monolithic VPC stack for backward
compatibility. New work must use:

- `modules/network/vpc` (+ subnets, igw, nat, route-tables, …)
- `compositions/network/network-foundation`
- `compositions/network/network-baseline` (compat wrapper)
