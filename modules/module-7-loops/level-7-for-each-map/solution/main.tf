variable "services" {
  type = map(string)
  default = {
    web = "nginx"
    db  = "postgres"
  }
}

resource "local_file" "service_config" {
  for_each = var.services
  content  = "service: ${each.key} = ${each.value}"
  filename = "${path.module}/service-${each.key}.txt"
}
