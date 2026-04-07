terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Backend credentials should be provided via environment variables:
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
  # Or via a -backend-config file excluded from source control.

  backend "local" {
    path = "terraform.tfstate"
  }
}
