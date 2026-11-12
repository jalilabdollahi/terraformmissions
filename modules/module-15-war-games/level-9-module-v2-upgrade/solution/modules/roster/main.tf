variable "members" {
  description = "Crew member => role."
  type        = map(string)
}

variable "shift_hours" {
  description = "Length of a duty shift printed on every card."
  type        = number
  default     = 8
}

resource "random_pet" "callsign" {
  for_each  = var.members
  length    = 2
  separator = "-"
}

resource "local_file" "duty_card" {
  for_each = var.members
  filename = "${path.root}/cards/${each.key}.txt"
  content  = <<-EOT
    ${each.key} / ${each.value}
    call-sign ${random_pet.callsign[each.key].id}
    shift ${var.shift_hours}h
  EOT
}

output "callsigns" {
  value = { for k, p in random_pet.callsign : k => p.id }
}
