# BUG: condition only accepts "prod", but default is "dev".
# terraform plan fails because the default violates its own validation.

variable "env" {
  type    = string
  default = "dev"

  validation {
    condition     = var.env == "prod"
    error_message = "env must be prod."
  }
}

output "environment" {
  value = var.env
}
