variable "species" {
  type = string
}

variable "week" {
  type = number
}

locals {
  humidity_targets = {
    oyster    = 85
    shiitake  = 78
    lionsmane = 90
  }
  batch_id = "${upper(substr(var.species, 0, 3))}-W${var.week}"
}

resource "local_file" "tray_card" {
  filename = "${path.root}/cards/${var.species}.txt"
  content  = "${local.batch_id} @ ${local.humidity_targets[var.species]}% RH\n"
}

output "batch_id" {
  value = local.batch_id
}

output "humidity_pct" {
  value = local.humidity_targets[var.species]
}

output "card_file" {
  value = local_file.tray_card.filename
}
