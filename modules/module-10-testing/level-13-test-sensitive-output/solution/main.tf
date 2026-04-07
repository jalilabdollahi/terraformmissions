variable "password" {
  type      = string
  sensitive = true
  default   = "secret123"
}

output "password" {
  value     = var.password
  sensitive = true
}
