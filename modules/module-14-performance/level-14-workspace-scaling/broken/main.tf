# BUG: The naming convention is wrong.
# Required: "${terraform.workspace}-token-${count.index + 1}"  (workspace first, dash separator)
# Broken:   "token_${count.index + 1}_${terraform.workspace}"  (wrong order, underscore separator)
resource "random_string" "workspace_tokens" {
  count   = 5
  length  = 10
  special = false
  upper   = false
  keepers = {
    name = "token_${count.index + 1}_${terraform.workspace}"
  }
}

output "workspace_name" {
  value = terraform.workspace
}

output "token_names" {
  value = [for i, t in random_string.workspace_tokens : "token_${i + 1}_${terraform.workspace}"]
}

output "token_values" {
  value = random_string.workspace_tokens[*].result
}
