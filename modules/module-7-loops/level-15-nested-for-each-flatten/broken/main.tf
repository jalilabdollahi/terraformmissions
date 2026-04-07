variable "services" {
  type = list(object({
    name  = string
    ports = list(number)
  }))
  default = [
    { name = "web",  ports = [80, 443] },
    { name = "api",  ports = [8080] },
  ]
}

# Wrong: nested for produces list of lists — toset() expects a flat list
resource "local_file" "port_configs" {
  for_each = toset([
    for svc in var.services : [
      for port in svc.ports : "${svc.name}-${port}"
    ]
  ])
  content  = "port config: ${each.key}"
  filename = "${path.module}/port-${each.key}.txt"
}
