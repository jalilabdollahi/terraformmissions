# Blue Reef Dive School - boat logbook.

resource "random_pet" "boat" {
  length    = 2
  separator = "-"
  prefix    = "reef"
}

resource "local_file" "logbook" {
  filename = "${path.module}/divelog/logbook.txt"
  content  = "Boat of the day: ${random_pet.boat.id}\n"
}

output "boat_name" {
  value = random_pet.boat.id
}
