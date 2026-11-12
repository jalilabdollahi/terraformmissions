variable "season" {
  type    = string
  default = "2023"
}

module "evaporator" {
  source = "./modules/evaporator"

  sugarbush = "Hollisford Sugarbush"
  season    = var.season
}

output "label" {
  value = module.evaporator.label
}
