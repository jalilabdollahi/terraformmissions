# Fireworks show control for the Brightwater Regatta.
# The cue sheet is rebuilt whenever the running order changes; a null_resource
# stamps a "cue sheet revision" marker so the pyro crew knows to re-read it.

locals {
  running_order = ["opening-salvo", "river-cascade", "golden-rain", "grand-finale"]
  safety_zone_m = 150
}

resource "null_resource" "cue_sheet" {
  triggers = {
    cues     = join(",", local.running_order)
    distance = local.safety_zone_m
  }
}

resource "local_file" "cue_sheet" {
  filename = "${path.module}/show/cues.txt"
  content  = "${join("\n", local.running_order)}\n"
}

output "cue_revision_id" {
  value = null_resource.cue_sheet.id
}
