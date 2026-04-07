locals {
  env_config = {
    default = "dev-config"
    staging = "stg-config"
  }

  current_config = local.env_config[terraform.workspace]
}

output "config_value" {
  value = local.current_config
}
