module "hut" {
  source = "./modules/hut"
  name   = "eagles-nest"
}

output "hut_key" {
  value = module.hut.key_hex
}
