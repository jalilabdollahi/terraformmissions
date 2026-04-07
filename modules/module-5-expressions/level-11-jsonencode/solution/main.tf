locals {
  config = {
    name    = "app"
    version = "1.0.0"
  }
  config_json = jsonencode(local.config)
}

output "config_json" {
  value = local.config_json
}
