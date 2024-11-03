terraform {
  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "Ambev-Lab1"

  #   workspaces {
  #     name = "myaws-lab1"
  #   }
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
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
  region = "us-east-1"
  default_tags {
    tags = {
      Owner       = "Lucas"
      Environment = "Lab1"
      Project     = "MyAWS"
      Provisoned  = "Terraform"
    }
  }
}