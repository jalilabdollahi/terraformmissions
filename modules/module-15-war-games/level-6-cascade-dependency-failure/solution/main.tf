module "module_a" {
  source = "./modules/module_a"
}

module "module_b" {
  source  = "./modules/module_b"
  input_a = module.module_a.output_value
}

module "module_c" {
  source  = "./modules/module_c"
  input_b = module.module_b.output_value
}

output "final_value" {
  value = module.module_c.output_value
}
