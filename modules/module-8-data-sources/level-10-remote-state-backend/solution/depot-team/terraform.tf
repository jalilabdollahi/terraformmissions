terraform {
  required_version = ">= 1.10"

  # The depot team keeps its state in a named file inside its own state/ folder.
  backend "local" {
    path = "state/depot.tfstate"
  }
}
