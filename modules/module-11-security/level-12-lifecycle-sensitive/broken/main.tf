resource "random_password" "service" {
  length  = 16
  special = false
}

resource "local_sensitive_file" "service_creds" {
  content  = random_password.service.result
  filename = "${path.module}/service.key"

  lifecycle {
    # Broken: ignoring content means Terraform will never fix a tampered credential file
    ignore_changes = [content]
  }
}
