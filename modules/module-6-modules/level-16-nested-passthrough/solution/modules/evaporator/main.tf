variable "sugarbush" {
  type = string
}

variable "season" {
  type = string
}

module "canner" {
  source = "./modules/canner"

  sugarbush = var.sugarbush
  season    = var.season
}

output "label" {
  value = module.canner.label
}
