variable "secret" {
  type      = string
  sensitive = true
  default   = "top-secret-value"
}

output "exposed_secret" {
  value     = var.secret
  sensitive = true
}
