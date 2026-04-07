resource "random_password" "db" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Broken: nonsensitive() strips the sensitive marking, then written to a world-readable file
resource "local_file" "db_password" {
  content  = nonsensitive(random_password.db.result)
  filename = "${path.module}/db_password.txt"
}

output "password_file" {
  value = local_file.db_password.filename
}

output "password_check" {
  value = "Password length: ${nonsensitive(length(random_password.db.result))}"
}
