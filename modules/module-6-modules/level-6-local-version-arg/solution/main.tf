variable "model" {
  type    = string
  default = "crane"
}

module "pattern" {
  source = "./modules/folds"

  model = var.model
}

output "steps" {
  value = module.pattern.step_count
}

output "sheet" {
  value = module.pattern.sheet_file
}
