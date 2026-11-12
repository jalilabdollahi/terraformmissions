# Charity shop till room: the takings safe's combination is kept in a file on the back-office laptop. The door card
# for the shift manager is generated from it.

data "local_file" "combination" {
  filename = "${path.module}/tillroom/combination.txt"
}

locals {
  dial_code = trimspace(data.local_file.combination.content)
}

resource "local_file" "door_card" {
  filename        = "${path.module}/tillroom/door-card.txt"
  file_permission = "0644"
  content         = "Shift manager - safe combination: ${local.dial_code}\n"
}

output "combination" {
  value = local.dial_code
}

output "card_path" {
  value = local_file.door_card.filename
}
