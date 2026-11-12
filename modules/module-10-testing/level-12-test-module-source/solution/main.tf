module "blocks" {
  source = "./modules/block"
}

module "border" {
  source = "./modules/border"
}

output "total_cm2" {
  value = module.blocks.fabric_cm2 + module.border.border_cm2
}
