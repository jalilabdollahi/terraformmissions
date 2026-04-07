module "storage" {
  source = "./modules/storage"
}

moved {
  from = local_file.config
  to   = module.storage.local_file.config
}
