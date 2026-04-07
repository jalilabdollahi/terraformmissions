variable "environment" {
  type    = string
  default = "dev"
}

output "environment" {
  value = var.environment
}
