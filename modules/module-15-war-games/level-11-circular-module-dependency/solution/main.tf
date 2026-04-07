# Cycle broken: shared_seed is created at root level.
# Both modules receive it as input — no cycle.
resource "random_string" "shared_seed" {
  length  = 8
  special = false
  upper   = false
}

module "module_a" {
  source      = "./modules/module_a"
  shared_seed = random_string.shared_seed.result
}

module "module_b" {
  source      = "./modules/module_b"
  shared_seed = random_string.shared_seed.result
}

output "combined" {
  value = "${module.module_a.output_a}-${module.module_b.output_b}"
}
