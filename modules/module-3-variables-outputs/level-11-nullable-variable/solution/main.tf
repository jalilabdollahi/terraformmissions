variable "environment" {
  type     = string
  nullable = false
  default  = "production"
}

output "environment" {
  value = var.environment
}
