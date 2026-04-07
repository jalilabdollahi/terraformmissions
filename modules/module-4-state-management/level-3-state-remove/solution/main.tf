resource "local_file" "file_a" {
  content  = "I am file A"
  filename = "${path.module}/file_a.txt"
}

resource "local_file" "file_b" {
  content  = "depends on: ${local_file.file_a.filename}"
  filename = "${path.module}/file_b.txt"
}
