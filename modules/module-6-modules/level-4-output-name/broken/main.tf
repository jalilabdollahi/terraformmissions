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
  value = module.cellar.batch_code
}

output "humidity" {
  value = module.cellar.humidity
}

output "card" {
  value = module.cellar.card_path
}
