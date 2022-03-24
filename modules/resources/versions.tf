
terraform {
  required_version = "~> 1.1"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.50"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }

  }
}