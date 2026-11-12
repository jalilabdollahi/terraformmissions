# Ridgeway Rickshaw Charity Rally — rally-day route cards.
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
  tag_label = format("TAG-%05d", var.rider.tag)
  pace      = format("%d:%02d", floor(var.rider.pace_seconds / 60), var.rider.pace_seconds % 60)
  card = format(
    "%s | %q | %05.1f km | pace %s min/km",
    local.tag_label,
    var.rider.name,
    var.rider.distance_km,
    local.pace,
  )
}

resource "local_file" "route_card" {
  filename = "${path.module}/cards/route-card.txt"
  content  = "${local.card}\n"
}

output "tag_label" {
  value = local.tag_label
}

output "card" {
  value = local.card
}
