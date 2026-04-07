variable "secret" {
  type      = string
  sensitive = true
}

resource "local_file" "secret_file" {
  content  = var.secret
  filename = "${path.module}/secret.txt"
}

# Missing: sensitive = true on this output
output "secret_content" {
  value = var.secret
}
