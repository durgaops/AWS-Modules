# LEGACY MODULE — prefer terraform/modules/network/* + compositions/network-foundation
#
# This monolithic VPC module remains for backward compatibility with early
# compositions (network-baseline). New work should use the granular network
# modules under modules/network/.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
