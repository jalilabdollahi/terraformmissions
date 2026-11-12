variable "BoathouseCode" {
  type      = string
  sensitive = true
}

variable "club-region" {
  type = string
}

variable "crew_roster" {
  type = list(string)
}

resource "local_sensitive_file" "keypad_code" {
  filename        = "${path.module}/boathouse/keypad-code.txt"
  content         = "${var.BoathouseCode}\n"
  file_permission = "0600"
}

resource "local_file" "door_card" {
  filename = "${path.module}/boathouse/door-card.txt"
  content  = "Region: ${var.club-region}\nCrew: ${join(",", var.crew_roster)}\n"
}

output "crew_size" {
  value = length(var.crew_roster)
}
