module "mymod" {
  source = "./modules/writer"
  providers = {
    local = local.primary
  }
}
