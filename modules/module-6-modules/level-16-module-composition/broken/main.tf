module "mod_a" {
  source = "./modules/mod_a"
}

# Wrong: Module B expects 'config_path' but we're passing 'config_file'.
module "mod_b" {
  source      = "./modules/mod_b"
  config_file = module.mod_a.config_path
}
