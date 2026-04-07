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

output "app_name" {
  value = var.config.name
}
