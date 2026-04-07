terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      # BUG: Wrong provider source namespace. The correct source is "hashicorp/random".
      source  = "hashicorp-legacy/random"
      version = "~> 3.6"
    }
  }
}
