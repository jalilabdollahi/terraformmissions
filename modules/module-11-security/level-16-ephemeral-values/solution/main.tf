variable "api_token" {
  type      = string
  sensitive = true
  default   = "token-abc123-secret"
}

resource "local_sensitive_file" "token_file" {
  content  = var.api_token
  filename = "${path.module}/token.txt"
}

output "token_location" {
  value = local_sensitive_file.token_file.filename
}

output "token_preview" {
  value     = var.api_token
  sensitive = true
}
