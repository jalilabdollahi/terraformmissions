resource "random_string" "tokens" {
  for_each = var.token_lengths
  length   = each.value
  special  = false
  upper    = false
}

output "token_results" {
  value = { for k, v in random_string.tokens : k => v.result }
}
