# BUG: default port is 80, but the precondition requires port >= 1024.
# terraform plan fails when using the default value.

variable "port" {
  type    = number
  default = 80
}

output "service_port" {
  value = var.port

  precondition {
    condition     = var.port >= 1024
    error_message = "port must be >= 1024 (use an unprivileged port)."
  }
}
