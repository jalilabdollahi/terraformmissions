# Rolling Thunder bowling alley: lane sheets built by a module, lane count chosen per workspace.

locals {
  lanes = {
    prod    = 4
    staging = 2
  }
}

module "alley" {
  source     = "./modules/lanes"
  site       = terraform.workspace
  lane_count = lookup(local.lanes, terraform.workspace, 1)
}

output "lane_files" {
  value = module.alley.lane_files
}
