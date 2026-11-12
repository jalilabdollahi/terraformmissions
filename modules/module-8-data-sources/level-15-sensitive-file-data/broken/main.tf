# Strongroom: the safe's combination is kept in a file on the vault laptop. The door card for the
# night manager is generated from it.

data "local_file" "combination" {
  filename = "${path.module}/vault/combination.txt"
}

locals {
  dial_code = trimspace(data.local_file.combination.content)
}

resource "local_file" "door_card" {
  filename        = "${path.module}/vault/door-card.txt"
  file_permission = "0644"
  content         = "Night manager - safe combination: ${local.dial_code}\n"
}

output "combination" {
  value = local.dial_code
}

output "card_path" {
  value = local_file.door_card.filename
}
