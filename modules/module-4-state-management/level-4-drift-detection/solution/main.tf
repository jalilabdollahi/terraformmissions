# Clay & Ember Pottery: kiln K2 firing schedule.
# The studio's controller reads kiln/firing-schedule.txt. Somebody changed the
# file directly on the machine, outside Terraform.

locals {
  kiln_id      = "K2"
  peak_temp_c  = 1320
  hold_minutes = 40
}

resource "local_file" "firing_schedule" {
  filename = "${path.module}/kiln/firing-schedule.txt"
  content  = <<-EOT
    kiln: ${local.kiln_id}
    peak_temp_c: ${local.peak_temp_c}
    hold_minutes: ${local.hold_minutes}
  EOT
}

resource "local_file" "glaze_notes" {
  filename = "${path.module}/kiln/glaze-notes.txt"
  content  = "Celadon glaze: cone 9, slow cool.\n"
}
