variable "port" {
  type    = number
  default = 8080
}

output "service_port" {
  value = var.port

  precondition {
    condition     = var.port >= 1024
    error_message = "port must be >= 1024 (use an unprivileged port)."
  }
}
