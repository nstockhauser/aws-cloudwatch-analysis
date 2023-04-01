terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }


  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "KEY"
  secret_key = "KEY"
}


