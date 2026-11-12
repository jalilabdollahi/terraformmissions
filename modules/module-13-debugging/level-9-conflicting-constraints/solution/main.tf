# Alpenrose mountain hut - weekend booking sheet.

module "bunks" {
  source = "./modules/bunks"
  hut    = "alpenrose"
}

module "meals" {
  source = "./modules/meals"
  hut    = "alpenrose"
}

resource "local_file" "booking_sheet" {
  filename = "${path.module}/hut/booking.txt"
  content  = "Bunk room ${module.bunks.room_label} | soup batch ${module.meals.soup_batch}\n"
}

output "room_label" {
  value = module.bunks.room_label
}

output "soup_batch" {
  value = module.meals.soup_batch
}
