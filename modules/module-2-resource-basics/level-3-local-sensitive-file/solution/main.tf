resource "local_sensitive_file" "secret" {
  content         = "super-secret-api-key=abc123"
  filename        = "${path.module}/secret.txt"
  file_permission = "0600"
}
