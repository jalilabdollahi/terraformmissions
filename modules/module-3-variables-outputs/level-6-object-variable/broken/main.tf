# BUG: default is missing the required "port" key defined in the object type.

variable "service" {
  type = object({
    name = string
    port = number
  })
  default = {
    name = "app"
  }
}

output "service_name" {
  value = var.service.name
}
