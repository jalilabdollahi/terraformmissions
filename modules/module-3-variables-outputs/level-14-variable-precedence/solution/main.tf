# Skyward Range — launch sequence sheet.
# Range safety reviewed terraform.tfvars; the sheet printed for the crew must match it.

resource "local_file" "sequence_sheet" {
  filename = "${path.module}/sheets/${replace(lower(var.pad_name), " ", "-")}.txt"
  content  = <<-EOT
    ${var.pad_name}: T-${var.countdown_minutes} min countdown
    Holds at: ${join(", ", [for h in var.hold_points : "T-${h}"])}
  EOT
}

output "pad" {
  value = var.pad_name
}

output "countdown_minutes" {
  value = var.countdown_minutes
}

output "hold_points" {
  value = var.hold_points
}
