resource "random_password" "app" {
  length  = 20
  special = true

  # Broken: timestamp() changes every plan — forces rotation on every apply
  keepers = {
    always_rotate = timestamp()
  }
}

resource "local_sensitive_file" "creds" {
  content  = "APP_PASSWORD=${random_password.app.result}"
  filename = "${path.module}/app-creds.txt"
}

output "password_set" {
  value = "Password has been set"
}
