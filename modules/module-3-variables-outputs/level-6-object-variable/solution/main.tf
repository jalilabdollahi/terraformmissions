variable "service" {
  type = object({
    name = string
    port = number
  })
  default = {
    name = "app"
    port = 8080
  }
}

output "service_name" {
  value = var.service.name
}
