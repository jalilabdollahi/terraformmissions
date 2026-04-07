# BUG: backend block references var.state_path — variables cannot be used in
# backend configuration because the backend is initialised before variables
# are resolved.
terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  backend "local" {
    path = var.state_path
  }
}
