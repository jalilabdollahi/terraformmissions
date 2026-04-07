resource "random_password" "service" {
  length  = 16
  special = false
}

resource "local_sensitive_file" "service_creds" {
  content  = random_password.service.result
  filename = "${path.module}/service.key"
}
