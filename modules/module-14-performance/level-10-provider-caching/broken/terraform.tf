terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      # BUG: This version does not exist. The cache would have ~> 3.6 but not 3.99.
      # Fix: use a valid constraint like ~> 3.6
      version = "= 3.99.0"
    }
  }
}
