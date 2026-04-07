# This resource uses ignore_changes = all which is an anti-pattern.
# It hides ALL configuration drift including actual bugs.
# Fix: only ignore the 'keepers' attribute which is intentionally externally managed.
resource "random_string" "cached_token" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = all
  }
}

output "token" {
  value = random_string.cached_token.result
}
