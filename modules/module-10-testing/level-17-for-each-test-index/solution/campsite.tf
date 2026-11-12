variable "vehicles" {
  description = "Vehicles staying at the campsite and their pitch numbers."
  type = map(object({
    kind  = string
    pitch = number
  }))
  default = {
    nomad   = { kind = "campervan", pitch = 3 }
    voyager = { kind = "caravan", pitch = 7 }
    drifter = { kind = "motorhome", pitch = 11 }
  }
}

resource "local_file" "pitch_card" {
  for_each = var.vehicles
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "Pitch ${each.value.pitch}: ${each.key} (${each.value.kind})\n"
}
