# BUG: environment should be type = string, not type = number.
# Passing -var="environment=staging" fails because "staging" is not a number.

variable "environment" {
  type    = number
  default = 0
}

output "environment" {
  value = var.environment
}
