variable "thickness_mm" {
  type    = number
  default = 25
}

module "chiller" {
  source = "./modules/chiller"

  thickness_mm = var.thickness_mm
}

module "resurfacer" {
  source = "./modules/resurfacer"

  log_path   = "${path.module}/rink/ice-log.txt"
  depends_on = [module.chiller]
}

output "resurface_after_min" {
  value = module.resurfacer.resurface_after_min
}
