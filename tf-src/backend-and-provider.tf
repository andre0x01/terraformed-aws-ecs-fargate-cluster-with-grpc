# Based on https://dev.to/thnery/create-an-aws-ecs-cluster-using-terraform-g80

variable "aws_region" {
  type = string
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}
variable "app_name" {
  type = string
}
variable "app_environment" {
  type        = string
  description = "Application Environment, e.g. dev,qa,prod"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  # terraform cloud
  backend "remote" {
    organization = "##your-organization###"
    workspaces {
      name = "##your-workspace-name###"
    }
  }
}
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

