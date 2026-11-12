terraform {
  required_version = ">= 1.10"
  required_providers {
    local = {
      source  = "hashicorp/localfile"
      version = "~> 2.5"
    }
  }
}
