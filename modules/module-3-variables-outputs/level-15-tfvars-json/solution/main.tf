# Kestrel Peak Observatory — dome configuration sheet.
# Inputs are exported from the booking system as terraform.tfvars.json.

locals {
  light_gathering = pow(var.mirror_diameter_m / 0.007, 2)
}

resource "local_file" "dome_sheet" {
  filename = "${path.module}/dome/sheet.txt"
  content  = <<-EOT
    ${var.observatory} (${var.site.lat}, ${var.site.lon})
    Mirror: ${var.mirror_diameter_m} m
    Instruments: ${join(", ", var.instruments)}
  EOT
}

output "observatory" {
  value = var.observatory
}

output "instrument_count" {
  value = length(var.instruments)
}

output "dome_latitude" {
  value = var.site.lat
}

output "light_gathering_vs_eye" {
  value = floor(local.light_gathering)
}
