terraform {
  required_version = ">= 1.10"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4, < 2.9"
    }
  }
}
