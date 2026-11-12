variable "orchard" {
  type = string
}

variable "vintage" {
  type = string
}

module "bottler" {
  source = "./modules/bottler"

  orchard = var.orchard
}

output "label" {
  value = module.bottler.label
}
