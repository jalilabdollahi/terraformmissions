variable "species" {
  type    = string
  default = "shiitake"
}

variable "week" {
  type    = number
  default = 14
}

module "cellar" {
  source = "./modules/cellar"

  species = var.species
  week    = var.week
}

output "batch" {
  value = module.cellar.batch_id
}

output "humidity" {
  value = module.cellar.humidity_pct
}

output "card" {
  value = module.cellar.card_file
}
