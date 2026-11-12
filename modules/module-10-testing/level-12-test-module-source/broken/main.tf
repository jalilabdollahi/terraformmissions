module "tiles" {
  source = "./modules/tile"
}

module "frieze" {
  source = "./modules/frieze"
}

output "total_cm2" {
  value = module.tiles.tile_cm2 + module.frieze.frieze_cm2
}
