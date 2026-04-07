variable "api_key" {
  type      = string
  default   = "super-secret-key"
  sensitive = true
}

output "api_key" {
  value     = var.api_key
  sensitive = true
}
