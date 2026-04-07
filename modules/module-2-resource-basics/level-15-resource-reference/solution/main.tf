resource "random_string" "token" {
  length  = 16
  special = false
}

resource "local_file" "output" {
  content  = "Token: ${random_string.token.result}"
  filename = "${path.module}/token.txt"
}
