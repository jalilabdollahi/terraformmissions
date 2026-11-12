# Rolling Thunder bowling alley: lane sheets built by a module, lane count chosen per workspace.

module "alley" {
  source     = "./modules/lanes"
  site       = terraform.workspace
  lane_count = terraform.workspace == "prod" ? 4 : terraform.workspace == "staging" ? 2 : 0
}

output "lane_files" {
  value = module.alley.lane_files
}
