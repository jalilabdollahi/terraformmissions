terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# BUG: The provider block references var.api_key, but the variable is named api_secret.
# This simulates a provider auth failure due to wrong credential variable name.
provider "local" {
  # local provider doesn't use API keys, but this pattern demonstrates the issue:
  # referencing a variable name that doesn't exist in variables.tf
  # (If this were AWS: access_key = var.api_key would fail; should be var.api_secret)
}
