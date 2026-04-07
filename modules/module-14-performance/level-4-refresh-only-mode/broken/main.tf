# This resource will be recreated (destroyed + created) if keepers change.
# In production, this could mean regenerating a secret token unexpectedly.
# Fix: add a lifecycle block with ignore_changes = [keepers] to prevent this.
resource "random_string" "api_token" {
  length  = 32
  special = false
  keepers = {
    version = "v1"
  }
}

output "api_token_value" {
  value     = random_string.api_token.result
  sensitive = true
}
