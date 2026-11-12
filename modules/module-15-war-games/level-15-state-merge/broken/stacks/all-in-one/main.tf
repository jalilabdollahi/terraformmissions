# Hollowbrook cider co-op - the merged stack. One state, one module per team.
# Written by hand from the three team configs; it has never been planned against real state.

module "orchard" {
  source    = "../../modules/team"
  team      = "orchard"
  quota_min = 200
  quota_max = 400
}

module "press" {
  source    = "../../modules/team"
  team      = "press"
  quota_min = 50
  quota_max = 210
  upstream  = module.orchard.batch
}

module "cellar" {
  source    = "../../modules/team"
  team      = "cellar"
  quota_min = 4
  quota_max = 90
  upstream  = module.press.batch
}
