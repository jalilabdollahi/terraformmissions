# Calder Reach Shipyard — registry of dry-dock berths.
# yard_charter is the serial on the yard's operating charter. It is filed with the harbour
# authority and printed on every classification certificate. Losing it means re-licensing.

resource "random_id" "yard_charter" {
  byte_length = 5

  keepers = {
    yard  = var.yard_name
    annex = "true"
  }

  lifecycle {
    prevent_destroy = true
  }
}

module "annex" {
  count  = var.annex_enabled ? 1 : 0
  source = "./modules/annex"

  yard_name = var.yard_name
}

resource "local_file" "yard_manifest" {
  filename = "${path.module}/registry/yard-manifest.txt"
  content  = <<-EOT
    yard     ${var.yard_name}
    charter  CH-${random_id.yard_charter.hex}
  EOT
}

output "charter_serial" {
  value = "CH-${random_id.yard_charter.hex}"
}
