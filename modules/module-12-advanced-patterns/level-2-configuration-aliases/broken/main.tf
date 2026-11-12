# Typewriter repair shop: ribbon reel numbers.
# The ribbon_stock module numbers a primary reel on the default provider and a spare
# reel on a second, named provider configuration kept for the back bench.

provider "random" {
  alias = "back_bench"
}

module "ribbons" {
  source = "./modules/ribbon_stock"
}

output "primary_reel" {
  value = module.ribbons.primary_reel
}

output "spare_reel" {
  value = module.ribbons.spare_reel
}
