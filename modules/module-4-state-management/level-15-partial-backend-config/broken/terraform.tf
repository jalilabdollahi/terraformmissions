terraform {
  required_version = ">= 1.10"

  # Partial configuration: the location of the state is supplied at init time
  # from a file, so the same code can be used by different stations.
  backend "local" {}

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}
