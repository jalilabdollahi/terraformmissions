variable "belts" {
  description = "Belt name => settings."
  type        = map(object({ capacity = number }))
}

resource "random_id" "belt" {
  for_each    = var.belts
  byte_length = 3
}

output "belt_serials" {
  value = { for k, r in random_id.belt : k => r.hex }
}

output "capacity" {
  value = { for k, b in var.belts : k => b.capacity }
}
