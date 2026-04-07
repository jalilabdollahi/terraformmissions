module "deploy" {
  source = "./modules/deployer"
  env    = "prod"
}
