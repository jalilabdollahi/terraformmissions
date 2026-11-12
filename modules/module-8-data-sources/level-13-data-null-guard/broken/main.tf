# Banquet hall: place cards are printed from the guest list the caterer exports as JSON.
# "table" and "diet" are optional: the caterer only fills them in when there is something to say.

data "local_file" "guest_list" {
  filename = "${path.module}/event/guests.json"
}

locals {
  guests = jsondecode(data.local_file.guest_list.content)

  cards = [
    for g in local.guests :
    "${g.name} | table ${g.table} | ${coalesce(g.diet, "no restrictions")}"
  ]
  special_diets = length([for g in local.guests : g.name if g.diet != null])
}

resource "local_file" "place_cards" {
  filename = "${path.module}/event/place-cards.txt"
  content  = "${join("\n", local.cards)}\n"
}

output "cards" {
  value = local.cards
}

output "special_diets" {
  value = local.special_diets
}
