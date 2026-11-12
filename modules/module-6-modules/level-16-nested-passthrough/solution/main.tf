variable "vintage" {
  type    = string
  default = "2023"
}

module "press" {
  source = "./modules/press"

  orchard = "Applewick Orchard"
  vintage = var.vintage
}

output "label" {
  value = module.press.label
}
