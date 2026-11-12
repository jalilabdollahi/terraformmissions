variable "sugarbush" {
  type = string
}

variable "season" {
  type = string
}

module "canner" {
  source = "./modules/canner"

  sugarbush = var.sugarbush
}

output "label" {
  value = module.canner.label
}
