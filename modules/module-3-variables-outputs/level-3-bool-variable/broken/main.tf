# BUG: default = "false" is a string, not a boolean.

variable "enable_logging" {
  type    = bool
  default = "false"
}

output "logging_enabled" {
  value = var.enable_logging
}
