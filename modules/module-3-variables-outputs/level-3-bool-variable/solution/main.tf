variable "enable_logging" {
  type    = bool
  default = false
}

output "logging_enabled" {
  value = var.enable_logging
}
