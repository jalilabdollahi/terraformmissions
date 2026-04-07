variable "password_version" {
  type    = string
  default = "v1"
  description = "Increment this value to trigger password rotation."
}

resource "random_password" "app" {
  length  = 20
  special = true

  keepers = {
    version = var.password_version
  }
}

resource "local_sensitive_file" "creds" {
  content  = "APP_PASSWORD=${random_password.app.result}"
  filename = "${path.module}/app-creds.txt"
}

output "password_set" {
  value = "Password has been set"
}
