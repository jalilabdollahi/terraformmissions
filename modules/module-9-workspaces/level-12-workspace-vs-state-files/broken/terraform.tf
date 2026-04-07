terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Invalid: backend blocks cannot use interpolation or expressions.
  # terraform.workspace is not available during backend initialisation.
  backend "local" {
    path = "workspaces/${terraform.workspace}/terraform.tfstate"
  }
}
