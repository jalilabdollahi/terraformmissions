# --- pouring ---------------------------------------------------------------------
resource "random_id" "batch" {
  byte_length = 3
  prefix      = var.batch_prefix
}

resource "local_file" "pour_sheet" {
  filename = "${path.root}/out/pour-sheet.txt"
  content  = "Pour ${random_id.batch.hex}: ${var.scent} soy wax at 62C\n"
}

# --- wick cutting ----------------------------------------------------------------
resource "local_file" "wick_spec" {
  filename = "${path.root}/out/wick-spec.txt"
  content  = "Cotton wick, ${var.wick_cm} cm\n"
}

# --- labelling -------------------------------------------------------------------
resource "local_file" "label" {
  filename = "${path.root}/out/label.txt"
  content  = "Batch ${random_id.batch.hex} | wick ${var.wick_cm} cm | scent: ${var.scent}\n"
}

output "label_text" {
  value = local_file.label.content
}
