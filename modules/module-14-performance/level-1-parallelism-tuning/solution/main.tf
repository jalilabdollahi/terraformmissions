# Performance tip (CORRECT): Use -parallelism=10 to control how many resource
# operations run concurrently. Default is 10. For provider rate-limiting
# scenarios, lower it (e.g. -parallelism=5). Never use 0 — it is invalid.

resource "random_string" "tokens" {
  count   = 10
  length  = 16
  special = false
}

output "token_count" {
  value = length(random_string.tokens[*].result)
}
