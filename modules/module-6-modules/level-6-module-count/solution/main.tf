module "mymod" {
  count  = 2
  source = "./modules/item"
  name   = "app-${count.index}"
}
