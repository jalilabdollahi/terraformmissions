variable "port" {
  type    = number
  default = 8080

  validation {
    condition     = var.port > 0
    error_message = "port must be a positive integer greater than 0."
  }
}

output "port" {
  value = var.port
}
