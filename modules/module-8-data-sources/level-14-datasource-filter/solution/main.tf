data "local_file" "services" {
  filename = "${path.module}/services.json"
}

locals {
  enabled_services = [for s in jsondecode(data.local_file.services.content) : s if s.enabled]
}

output "enabled" {
  value = local.enabled_services
}
