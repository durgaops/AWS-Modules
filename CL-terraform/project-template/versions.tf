terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Backend config supplied at init time:
  #   terraform init -backend-config=backends/dev.hcl
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}
