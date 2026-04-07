terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Invalid: cannot use terraform.workspace interpolation inside backend block
  backend "local" {
    path = "terraform-${terraform.workspace}.tfstate"
  }
}
