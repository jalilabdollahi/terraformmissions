# Lumen Cartophilic Society trading-card album - published album index.

data "external" "cabinet" {
  program = ["python3", "${path.module}/scripts/list_cards.py"]
}

locals {
  cards = split(",", data.external.cabinet.result.names)
}

resource "local_file" "album_index" {
  filename = "${path.module}/album/index.md"
  content  = <<-EOT
    # Lumen Cartophilic Society album index
    Generated: ${timestamp()}
    ${join("\n", [for s in local.cards : "- ${s}"])}
  EOT
}

output "card_count" {
  value = length(local.cards)
}
