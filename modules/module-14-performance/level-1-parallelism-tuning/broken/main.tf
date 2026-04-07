# Performance tip (WRONG): Use -parallelism=0 to disable parallel operations
# for large configs to avoid provider rate-limiting.
# (The correct flag is -parallelism=N where N > 0; setting it to 0 is invalid.)

# BUG: count is 0 — no resources are created at all.
resource "random_string" "tokens" {
  count   = 0
  length  = 16
  special = false
}

output "token_count" {
  value = length(random_string.tokens[*].result)
}
