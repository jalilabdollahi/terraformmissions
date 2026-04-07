terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~3.6"   # Invalid: ~3.6 is not valid syntax
    }
  }
}
