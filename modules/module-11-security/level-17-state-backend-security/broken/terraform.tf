terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Simulated partial backend config — DO NOT hardcode credentials here
  # access_key = "AKIAIOSFODNN7EXAMPLE"   # <-- SECURITY VIOLATION: secret in source
  # secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

  backend "local" {
    path = "terraform.tfstate"
  }
}
