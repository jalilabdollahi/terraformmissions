resource "random_integer" "station_slot" {
  min = 1
  max = 6
}

module "glitter" {
  source = "./modules/glitter"
}

output "ticket" {
  value = "station-${random_integer.station_slot.result}/scoops-${module.glitter.scoops}"
}
