data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  parsed = jsondecode(data.local_file.config.content)
}

output "app_name" {
  value = local.parsed["app_name"]
}
