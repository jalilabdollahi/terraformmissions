# BUG: nullable = false means the variable cannot be null,
# but default = null sets the default to null. Contradiction.

variable "environment" {
  type     = string
  nullable = false
  default  = null
}

output "environment" {
  value = var.environment
}
