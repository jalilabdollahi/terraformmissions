module "shed" {
  source = "./modules/shed"
}

output "ticket" {
  value = module.shed.ticket
}
