# Ridgeway Endurance Ride — ride-day vet cards.
# Each rider's card is one printed line: tag, quoted name, distance, pace.

variable "rider" {
  type = object({
    name         = string
    tag          = number
    distance_km  = number
    pace_seconds = number
  })
  default = {
    name         = "Ines \"Flash\" Okafor"
    tag          = 7
    distance_km  = 21.1
    pace_seconds = 291
  }
}

locals {
  tag_label = format("TAG-%5d", var.rider.tag)
  pace      = format("%d:%02d", floor(var.rider.pace_seconds / 60), var.rider.pace_seconds % 60)
  card = format(
    "%s | %s | %d km | pace %s min/km",
    local.tag_label,
    var.rider.name,
    var.rider.distance_km,
    local.pace,
  )
}

resource "local_file" "vet_card" {
  filename = "${path.module}/cards/vet-card.txt"
  content  = "${local.card}\n"
}

output "tag_label" {
  value = local.tag_label
}

output "card" {
  value = local.card
}
