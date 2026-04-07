# BUG: local_sensitive_file requires file_permission to be set explicitly.
# The attribute is missing from this resource block.

resource "local_sensitive_file" "secret" {
  content  = "super-secret-api-key=abc123"
  filename = "${path.module}/secret.txt"
}
