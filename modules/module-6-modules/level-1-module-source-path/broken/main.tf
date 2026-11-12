variable "farm" {
  type    = string
  default = "Tarndale"
}

variable "clip" {
  type    = string
  default = "summer"
}

module "grading" {
  source = "modules/grading"

  farm = var.farm
  clip = var.clip
}

output "label_file" {
  value = module.grading.label_path
}
