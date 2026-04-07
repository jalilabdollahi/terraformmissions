resource "random_password" "db" {
  length  = 24
  special = false
}

resource "local_sensitive_file" "credentials" {
  content  = "DB_PASSWORD=${random_password.db.result}"
  filename = "${path.module}/credentials.txt"
}
