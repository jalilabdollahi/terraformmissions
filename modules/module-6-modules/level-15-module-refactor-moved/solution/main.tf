module "new" {
  source = "./modules/datamod"
}

moved {
  from = module.old
  to   = module.new
}
