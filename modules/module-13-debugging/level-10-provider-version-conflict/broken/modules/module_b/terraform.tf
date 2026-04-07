terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      # Bug: >= 3.0 conflicts with module_a's ~> 2.4 (no version satisfies both)
      version = ">= 3.0"
    }
  }
}
