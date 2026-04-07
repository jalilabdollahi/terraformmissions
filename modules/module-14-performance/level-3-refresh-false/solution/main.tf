resource "random_string" "cached_token" {
  length  = 16
  special = false

  lifecycle {
    ignore_changes = [keepers]
  }
}

output "token" {
  value = random_string.cached_token.result
}
