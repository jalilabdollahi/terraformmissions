terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 99.0"  # No such version exists
    }
  }
}
