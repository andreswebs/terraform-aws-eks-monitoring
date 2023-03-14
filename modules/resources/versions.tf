
terraform {
  required_version = "~> 1.3"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }

  }
}