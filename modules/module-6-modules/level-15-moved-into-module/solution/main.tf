module "hangar" {
  source = "./modules/hangar"
}

moved {
  from = random_id.ticket
  to   = module.hangar.random_id.ticket
}

moved {
  from = local_file.manifest
  to   = module.hangar.local_file.manifest
}

output "ticket" {
  value = module.hangar.ticket
}
