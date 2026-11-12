terraform {
  required_providers {
    random = {
      source                = "hashicorp/random"
      configuration_aliases = [random.spare]
    }
  }
}
