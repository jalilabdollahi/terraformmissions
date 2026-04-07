# The map lookup syntax is wrong — locals.env_config[terraform.workspace]
# is not valid; you access locals via local.env_config, not locals.env_config.
# Fix: change locals.env_config to local.env_config

locals {
  env_config = {
    default = "dev-config"
    staging = "stg-config"
  }

  current_config = locals.env_config[terraform.workspace]
}

output "config_value" {
  value = local.current_config
}
