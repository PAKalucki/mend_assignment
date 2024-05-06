terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.48.0"
    }
  }

  cloud {
    organization = "pakalucki"
    workspaces {
      name = "mendio_aws"
    }
  }
}

provider "aws" {
  profile = "mendio"
  region  = var.region

  default_tags {
    tags = {
      Created_by = "pakalucki@gmail.com"
    }
  }
}

data "aws_caller_identity" "current" {}