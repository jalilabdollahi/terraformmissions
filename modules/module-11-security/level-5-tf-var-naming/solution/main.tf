variable "armoury_code" {
  type      = string
  sensitive = true
}

variable "club_region" {
  type = string
}

variable "squad_roster" {
  type = list(string)
}

resource "local_sensitive_file" "keypad_code" {
  filename        = "${path.module}/armoury/keypad-code.txt"
  content         = "${var.armoury_code}\n"
  file_permission = "0600"
}

resource "local_file" "door_card" {
  filename = "${path.module}/armoury/door-card.txt"
  content  = "Region: ${var.club_region}\nSquad: ${join(",", var.squad_roster)}\n"
}

output "squad_size" {
  value = length(var.squad_roster)
}
