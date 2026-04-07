# data.local_file.services.content is a STRING, not a list.
# The for expression cannot iterate over a string directly.
# Fix: wrap the content in jsondecode() before the for expression.

data "local_file" "services" {
  filename = "${path.module}/services.json"
}

locals {
  enabled_services = [for s in data.local_file.services.content : s if s.enabled]
}

output "enabled" {
  value = local.enabled_services
}
