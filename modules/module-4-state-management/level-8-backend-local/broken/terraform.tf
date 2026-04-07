terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  # BUG: path points to a nonexistent directory
  backend "local" {
    path = "../../nonexistent/terraform.tfstate"
  }
}
