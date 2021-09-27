terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    okta = {
      source  = "okta/okta"
      version = "3.13.8"
    }
  }
  required_version = ">= 1"
}
