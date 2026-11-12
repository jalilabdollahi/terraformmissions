# Foxglove tea room: seasonal blend codename and its shelf card.

resource "random_pet" "blend" {
  length    = 2
  prefix    = "chai"
  separator = "-"
}

resource "local_file" "blend_card" {
  filename = "${path.module}/out/blend-card.txt"
  content  = "Seasonal blend: ${random_pet.blend.id}\n"
}

output "blend_name" {
  value = random_pet.blend.id
}
