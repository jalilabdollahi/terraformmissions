module "hangar" {
  source = "./modules/hangar"
}

output "ticket" {
  value = module.hangar.ticket
}
