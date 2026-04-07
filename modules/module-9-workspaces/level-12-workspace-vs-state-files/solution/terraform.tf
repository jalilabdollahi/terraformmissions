terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Static backend path — Terraform workspaces handle state isolation automatically.
  # Non-default workspaces store state in terraform.tfstate.d/<workspace>/terraform.tfstate
  backend "local" {
    path = "terraform.tfstate"
  }
}
