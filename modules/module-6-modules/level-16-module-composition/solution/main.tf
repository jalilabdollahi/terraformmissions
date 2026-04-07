module "mod_a" {
  source = "./modules/mod_a"
}

module "mod_b" {
  source      = "./modules/mod_b"
  config_path = module.mod_a.config_path
}
