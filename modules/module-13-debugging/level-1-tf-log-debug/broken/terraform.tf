terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      # Bug: wrong registry — this provider does not exist
      source  = "fakecorp.example.com/fakens/local"
      version = "~> 2.5"
    }
  }
}
