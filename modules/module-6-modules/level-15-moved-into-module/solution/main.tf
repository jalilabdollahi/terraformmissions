module "shed" {
  source = "./modules/shed"
}

moved {
  from = random_id.ticket
  to   = module.shed.random_id.ticket
}

moved {
  from = local_file.manifest
  to   = module.shed.local_file.manifest
}

output "ticket" {
  value = module.shed.ticket
}
