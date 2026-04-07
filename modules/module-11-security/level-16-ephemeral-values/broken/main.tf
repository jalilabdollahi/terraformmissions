variable "api_token" {
  type      = string
  sensitive = true
  default   = "token-abc123-secret"
}

# Broken: local_file does not enforce restrictive permissions and exposes the token
resource "local_file" "token_file" {
  content  = var.api_token
  filename = "${path.module}/token.txt"
}

# Broken: output exposes the sensitive value without sensitive = true
output "token_location" {
  value = local_file.token_file.filename
}

output "token_preview" {
  value = var.api_token
}
