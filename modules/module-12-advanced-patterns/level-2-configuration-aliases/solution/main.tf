# Fishing tackle shop: reel serial numbers.
# The reel_stock module numbers a primary reel on the default provider and a spare
# reel on a second, named provider configuration kept for the back wall.

provider "random" {
  alias = "back_wall"
}

module "reels" {
  source = "./modules/reel_stock"

  providers = {
    random       = random
    random.spare = random.back_wall
  }
}

output "primary_reel" {
  value = module.reels.primary_reel
}

output "spare_reel" {
  value = module.reels.spare_reel
}
