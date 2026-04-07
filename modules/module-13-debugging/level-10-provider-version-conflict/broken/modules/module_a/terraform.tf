terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      # Bug: ~> 2.4 conflicts with module_b's >= 3.0
      version = "~> 2.4"
    }
  }
}
