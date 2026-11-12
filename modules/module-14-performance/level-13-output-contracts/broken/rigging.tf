# Rigging team. DO NOT EDIT: this is their pipeline and it has not been migrated yet.

resource "local_file" "rigging_limit" {
  filename = "${path.module}/rigs/rigging.txt"
  content  = "Rigging load limit: ${module.stage.power_kw} kW\n"
}
