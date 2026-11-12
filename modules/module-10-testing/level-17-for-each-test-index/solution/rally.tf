variable "trucks" {
  description = "Trucks attending the rally and their pitch numbers."
  type = map(object({
    cuisine = string
    pitch   = number
  }))
  default = {
    tacotl  = { cuisine = "mexican", pitch = 3 }
    pierogi = { cuisine = "polish", pitch = 7 }
    waffle  = { cuisine = "belgian", pitch = 11 }
  }
}

resource "local_file" "board_card" {
  for_each = var.trucks
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "Pitch ${each.value.pitch}: ${each.key} (${each.value.cuisine})\n"
}
