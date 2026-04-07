resource "random_password" "db" {
  length  = 24
  special = false
}

# Broken: writing the password to a world-readable local_file
resource "local_file" "credentials" {
  content  = "DB_PASSWORD=${random_password.db.result}"
  filename = "${path.module}/credentials.txt"
}
