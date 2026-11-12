# Hollowbrook Saffron Growers' Co-op - the merged stack. One state, one module per team.
# Written by hand from the three team configs; it has never been planned against real state.

module "fields" {
  source    = "../../modules/team"
  team      = "fields"
  quota_min = 200
  quota_max = 400
}

module "drying" {
  source    = "../../modules/team"
  team      = "drying"
  quota_min = 50
  quota_max = 210
  upstream  = module.fields.batch
}

module "packing" {
  source    = "../../modules/team"
  team      = "packing"
  quota_min = 4
  quota_max = 90
  upstream  = module.drying.batch
}
