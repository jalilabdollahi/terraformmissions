# Feeding charts for the Northgate sled-dog kennel.
# One chart per dog on the roster, pinned to the dog's kennel door.

locals {
  dog_slugs = [for d in var.dogs : lower(d)]
}

resource "local_file" "feeding_chart" {
  count    = 3
  filename = "${path.module}/charts/${local.dog_slugs[count.index]}.txt"
  content  = "${var.dogs[count.index]}: ${var.ration_kg} kg of fish-and-rice mix, twice a day\n"
}

output "chart_total" {
  value = length(local_file.feeding_chart)
}
