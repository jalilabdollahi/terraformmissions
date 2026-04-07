terraform {
  required_version = "= 0.11.0"   # Forces an ancient version
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
