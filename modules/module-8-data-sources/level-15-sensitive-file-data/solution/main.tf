# Casino count room: the drop safe's combination is kept in a file on the cage laptop. The door card for the
# pit boss is generated from it.

data "local_sensitive_file" "combination" {
  filename = "${path.module}/countroom/combination.txt"
}

locals {
  dial_code = trimspace(data.local_sensitive_file.combination.content)
}

resource "local_file" "door_card" {
  filename        = "${path.module}/countroom/door-card.txt"
  file_permission = "0600"
  content         = "Pit boss - safe combination: ${local.dial_code}\n"
}

output "combination" {
  value     = local.dial_code
  sensitive = true
}

output "card_path" {
  value = local_file.door_card.filename
}
