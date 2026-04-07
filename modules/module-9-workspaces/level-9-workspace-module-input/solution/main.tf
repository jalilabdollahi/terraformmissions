locals {
  env_map = {
    default    = "development"
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
