# Pinewood Trail Marathon — race-day bib cards.
# Each runner's card is one printed line: bib, quoted name, distance, pace.

variable "runner" {
  type = object({
    name         = string
    bib          = number
    distance_km  = number
    pace_seconds = number
  })
  default = {
    name         = "Ines \"Flash\" Okafor"
    bib          = 7
    distance_km  = 21.1
    pace_seconds = 291
  }
}

locals {
  bib_label = format("BIB-%5d", var.runner.bib)
  pace      = format("%d:%02d", floor(var.runner.pace_seconds / 60), var.runner.pace_seconds % 60)
  card = format(
    "%s | %s | %d km | pace %s min/km",
    local.bib_label,
    var.runner.name,
    var.runner.distance_km,
    local.pace,
  )
}

resource "local_file" "bib_card" {
  filename = "${path.module}/cards/bib-card.txt"
  content  = "${local.card}\n"
}

output "bib_label" {
  value = local.bib_label
}

output "card" {
  value = local.card
}
