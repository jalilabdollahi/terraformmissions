# wrong_alias does not exist — only 'primary' is declared above.
module "mymod" {
  source = "./modules/writer"
  providers = {
    local = local.wrong_alias
  }
}
