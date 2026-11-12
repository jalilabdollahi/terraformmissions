# Tern Field Airport — baggage hall control plane, three chained modules:
#   belts (A)  ->  sorters (B)  ->  dispatch (C)
# The "capacity-aware sortation" release rewrote all three modules at once.
# Belt serials are engraved on the belt controllers; they must not change.

locals {
  belt_names = ["B1", "B2", "B3", "B4"]
  capacities = { B1 = 40, B2 = 40, B3 = 30, B4 = 20 }

  assignments = {
    transfer = ["B1", "B2"]
    arrivals = ["B3", "B4"]
  }
}

module "belts" {
  source = "./modules/belts"

  belts = { for b, c in local.capacities : b => { capacity = c } }
}

module "sorters" {
  source = "./modules/sorters"

  belt_serials = module.belts.belt_serials
  capacity     = module.belts.capacity
  assignments  = local.assignments
}

module "dispatch" {
  source = "./modules/dispatch"

  loads = module.sorters.loads
}

output "belt_serials" {
  value = module.belts.belt_serials
}

output "total_capacity" {
  value = module.dispatch.total_capacity
}

output "busiest_sorter" {
  value = module.dispatch.busiest
}
