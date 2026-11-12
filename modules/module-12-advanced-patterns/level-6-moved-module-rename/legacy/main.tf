# Kallmark salt mine: one inspection module per shaft.
# The first shaft's module call used to be named "shaft_a". It was renamed to
# "north_shaft" to match the second one, "south_shaft".

module "shaft_a" {
  source = "./modules/shaft"
  name   = "north"
  depth  = 140
}

module "south_shaft" {
  source = "./modules/shaft"
  name   = "south"
  depth  = 95
}

output "north_tag" {
  value = module.shaft_a.tag
}

output "south_tag" {
  value = module.south_shaft.tag
}
