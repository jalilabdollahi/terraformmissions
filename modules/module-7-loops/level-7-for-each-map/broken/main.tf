variable "services" {
  type = map(string)
  default = {
    web = "nginx"
    db  = "postgres"
  }
}

resource "local_file" "service_config" {
  for_each = var.services
  # Wrong: each.name doesn't exist — use each.key
  content  = "service: ${each.name} = ${each.value}"
  filename = "${path.module}/service-${each.name}.txt"
}
