resource "random_string" "token" {
  length  = 16
  special = false
}

# BUG: references the whole resource object, not the .result attribute.
resource "local_file" "output" {
  content  = "Token: ${random_string.token}"
  filename = "${path.module}/token.txt"
}
