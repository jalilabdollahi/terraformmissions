resource "random_password" "api_key" {
  length  = 32
  special = false
}

resource "local_sensitive_file" "api_key" {
  content  = random_password.api_key.result
  filename = "${path.module}/api_key.txt"

  file_permission = "0600"
}
