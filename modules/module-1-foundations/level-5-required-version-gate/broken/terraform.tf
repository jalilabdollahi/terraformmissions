terraform {
  # Written back when the harbour office ran Terraform 0.12 on one old laptop.
  required_version = ">= 0.12, < 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
