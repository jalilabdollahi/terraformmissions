# Willow Wren houseboat rental - weekend booking sheet.

module "berths" {
  source = "./modules/berths"
  boat   = "willow-wren"
}

module "galley" {
  source = "./modules/galley"
  boat   = "willow-wren"
}

resource "local_file" "booking_sheet" {
  filename = "${path.module}/boat/booking.txt"
  content  = "Cabin ${module.berths.cabin_label} | galley batch ${module.galley.supply_batch}\n"
}

output "cabin_label" {
  value = module.berths.cabin_label
}

output "supply_batch" {
  value = module.galley.supply_batch
}
