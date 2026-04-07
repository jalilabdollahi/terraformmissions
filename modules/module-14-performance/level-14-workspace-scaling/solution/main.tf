resource "random_string" "workspace_tokens" {
  count   = 5
  length  = 10
  special = false
  upper   = false
  keepers = {
    name = "${terraform.workspace}-token-${count.index + 1}"
  }
}

output "workspace_name" {
  value = terraform.workspace
}

output "token_names" {
  value = [for i, t in random_string.workspace_tokens : "${terraform.workspace}-token-${i + 1}"]
}

output "token_values" {
  value = random_string.workspace_tokens[*].result
}
