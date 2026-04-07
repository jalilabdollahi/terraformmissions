# CIRCULAR DEPENDENCY:
# module_a takes module_b's output as input
# module_b takes module_a's output as input
# This is a cycle — Terraform cannot determine evaluation order.
#
# Fix: extract the shared_seed to root level, pass it to both modules.
module "module_a" {
  source       = "./modules/module_a"
  input_from_b = module.module_b.output_b
}

module "module_b" {
  source       = "./modules/module_b"
  input_from_a = module.module_a.output_a
}

output "combined" {
  value = "${module.module_a.output_a}-${module.module_b.output_b}"
}
