# Uses random_string provider but the lock file has a wrong/stale hash.
# Fix: delete .terraform.lock.hcl and let terraform init -upgrade regenerate it.

resource "random_string" "token" {
  length  = 16
  special = false
}

output "token" {
  value = random_string.token.result
}
