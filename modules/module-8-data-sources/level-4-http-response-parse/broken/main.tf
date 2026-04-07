# The jsondecode call accesses "wrong_key" which does not exist in config.json.
# Fix: change "wrong_key" to "app_name" (or another key that exists in the JSON)

data "local_file" "config" {
  filename = "${path.module}/config.json"
}

locals {
  parsed = jsondecode(data.local_file.config.content)
}

output "app_name" {
  value = local.parsed["wrong_key"]
}
