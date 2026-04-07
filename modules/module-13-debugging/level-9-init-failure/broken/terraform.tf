terraform {
  required_version = ">= 1.5"
  required_providers {
    # Bug: this provider does not exist anywhere
    myfakelocal = {
      source  = "notarealregistry.example.com/fake/provider"
      version = "~> 1.0"
    }
  }
}
