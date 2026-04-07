# count = 2 but name is not passed — the child module requires it.
module "mymod" {
  count  = 2
  source = "./modules/item"
}
