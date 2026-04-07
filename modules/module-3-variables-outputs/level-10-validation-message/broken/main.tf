# BUG: error_message cannot be an empty string.

variable "port" {
  type    = number
  default = 8080

  validation {
    condition     = var.port > 0
    error_message = ""
  }
}

output "port" {
  value = var.port
}
