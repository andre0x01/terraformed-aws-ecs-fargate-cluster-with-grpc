terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  backend "remote" {
    organization = "andy0x01-pet-projects"
    workspaces {
      name = "pet-projects"
    }
  }
}
