variable "password" {
  type      = string
  sensitive = true

  validation {
    condition     = length(var.password) >= 8
    error_message = "Password must be at least 8 characters long."
  }
}

resource "local_sensitive_file" "password_file" {
  content  = var.password
  filename = "${path.module}/password.txt"
}
