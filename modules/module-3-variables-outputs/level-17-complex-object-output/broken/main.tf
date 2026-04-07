variable "config" {
  type = object({
    name    = string
    version = number
  })
  default = {
    name    = "my-app"
    version = 2
  }
}

# BUG: var.config has no key "nonexistent_key". Use var.config.name instead.
output "app_name" {
  value = var.config.nonexistent_key
}
