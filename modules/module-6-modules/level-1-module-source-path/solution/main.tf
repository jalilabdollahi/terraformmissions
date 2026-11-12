variable "estate" {
  type    = string
  default = "Glenburn"
}

variable "flush" {
  type    = string
  default = "second"
}

module "grading" {
  source = "./modules/grader"

  estate = var.estate
  flush  = var.flush
}

output "label_file" {
  value = module.grading.label_path
}
