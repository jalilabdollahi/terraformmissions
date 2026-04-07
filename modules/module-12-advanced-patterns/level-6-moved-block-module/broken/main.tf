module "storage" {
  source = "./modules/storage"
}

# Bug: 'to' references module.wrong_module which doesn't exist
moved {
  from = local_file.config
  to   = module.wrong_module.local_file.config
}
