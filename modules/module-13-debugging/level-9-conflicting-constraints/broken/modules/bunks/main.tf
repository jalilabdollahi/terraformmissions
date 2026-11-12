variable "hut" {
  type = string
}

resource "random_pet" "room" {
  length    = 2
  separator = "-"
  prefix    = "${var.hut}-room"
}

output "room_label" {
  value = random_pet.room.id
}
