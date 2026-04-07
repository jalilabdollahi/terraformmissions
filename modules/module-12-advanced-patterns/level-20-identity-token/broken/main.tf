# Simulates an auth token configuration pattern.
# The token variable has a broken validation regex that rejects valid tokens.

variable "auth_token" {
  type        = string
  description = "Authentication token for the service."
  default     = "MyService-Token-ABC123-xyz789-ABCDEF"

  validation {
    # Bug: regex only allows lowercase hex [0-9a-f], rejecting uppercase and hyphens
    condition     = can(regex("^[0-9a-f]{32,128}$", var.auth_token))
    error_message = "auth_token must be a valid token (alphanumeric and hyphens, 32-128 chars)."
  }
}

resource "local_file" "auth_config" {
  content         = "token=${var.auth_token}"
  filename        = "${path.module}/auth.cfg"
  file_permission = "0600"
}

output "token_length" {
  value = length(var.auth_token)
}
