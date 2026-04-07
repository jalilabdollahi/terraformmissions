locals {
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
}

output "environment" {
  value = local.env
}
