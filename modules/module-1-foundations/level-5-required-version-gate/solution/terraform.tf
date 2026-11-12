terraform {
  # Written back when the harbour office ran Terraform 0.12 on one old laptop.
  required_version = ">= 1.10"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
