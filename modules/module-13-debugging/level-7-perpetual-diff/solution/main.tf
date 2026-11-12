# Lumen Cartophilic Society trading-card album - published album index.

data "external" "cabinet" {
  program = ["python3", "${path.module}/scripts/list_cards.py"]
}

# Stamped once, when the index is first created, and then kept.
resource "time_static" "catalogued" {}

locals {
  cards = sort(split(",", data.external.cabinet.result.names))
}

resource "local_file" "album_index" {
  filename = "${path.module}/album/index.md"
  content  = <<-EOT
    # Lumen Cartophilic Society album index
    Generated: ${time_static.catalogued.rfc3339}
    ${join("\n", [for s in local.cards : "- ${s}"])}
  EOT
}

output "card_count" {
  value = length(local.cards)
}
