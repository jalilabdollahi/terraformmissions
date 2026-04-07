# The comparison uses an unquoted identifier "default" instead of the string "default".
# Fix: add quotes around default in the condition.

locals {
  env = terraform.workspace == default ? "dev" : terraform.workspace
}

output "environment" {
  value = local.env
}
