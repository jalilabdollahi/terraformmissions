variable "api_key" {
  type      = string
  default   = "super-secret-key"
  sensitive = true
}

# BUG: sensitive = "true" is a string, not a boolean.
output "api_key" {
  value     = var.api_key
  sensitive = "true"
}
