locals {
  belt_names  = ["B1", "B2", "B3", "B4"]
  assignments = { transfer = ["B1", "B2"], arrivals = ["B3", "B4"] }
}
module "belts" {
  source = "./modules/belts"
  belts  = local.belt_names
}
module "sorters" {
  source      = "./modules/sorters"
  belt_ids    = module.belts.belt_ids
  assignments = local.assignments
}
module "dispatch" {
  source = "./modules/dispatch"
  loads  = module.sorters.loads
}
