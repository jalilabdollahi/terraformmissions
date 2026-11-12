# --- pouring ---------------------------------------------------------------------
resource "random_id" "batch" {
  byte_length = 3
  prefix      = var.batch_prefix
}

resource "local_file" "pour_sheet" {
  filename = "${path.root}/out/pour-sheet.txt"
  content  = "Pour ${random_id.batch.hex}: ${var.shade} paraffin wax at 62C\n"
}

# --- colour mixing ---------------------------------------------------------------
resource "local_file" "colour_spec" {
  filename = "${path.root}/out/colour-spec.txt"
  content  = "Pigment load, ${var.pigment_pct} percent\n"
}

# --- labelling -------------------------------------------------------------------
resource "local_file" "label" {
  filename = "${path.root}/out/label.txt"
  content  = "Batch ${random_id.batch.hex} | pigment ${var.pigment_pct}% | shade: ${var.shade}\n"
}

output "label_text" {
  value = local_file.label.content
}
