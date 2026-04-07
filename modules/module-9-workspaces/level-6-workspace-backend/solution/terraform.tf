terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Static path — workspaces automatically store state in separate subdirectories
  backend "local" {
    path = "terraform.tfstate"
  }
}
