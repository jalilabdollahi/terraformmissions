# The env_map is missing the "default" workspace key.
# Fix: add "default" = "development" to the env_map.

locals {
  env_map = {
    staging    = "staging"
    production = "production"
  }
}

module "writer" {
  source     = "./modules/writer"
  env        = local.env_map[terraform.workspace]
  output_dir = path.module
}

output "path" {
  value = module.writer.marker_path
}
