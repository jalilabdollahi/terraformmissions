resource "random_id" "batch" {
  byte_length = 3
  prefix      = var.batch_prefix
}

resource "local_file" "pour_sheet" {
  filename = "${path.root}/out/pour-sheet.txt"
  content  = "Pour ${random_id.batch.hex}: ${var.shade} paraffin wax at 62C\n"
}

output "batch_code" {
  value = random_id.batch.hex
}
