variable "entries" {
  description = "Cars entered in the concours and their stand numbers."
  type = map(object({
    kind  = string
    stand = number
  }))
  default = {
    arrow  = { kind = "roadster", stand = 3 }
    regent = { kind = "saloon", stand = 7 }
    falcon = { kind = "coupe", stand = 11 }
  }
}

resource "local_file" "stand_card" {
  for_each = var.entries
  filename = "${path.module}/cards/${each.key}.txt"
  content  = "Stand ${each.value.stand}: ${each.key} (${each.value.kind})\n"
}
