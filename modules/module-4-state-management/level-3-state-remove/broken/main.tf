# Two local_file resources where each references the other's filename in its content.
# BUG: circular dependency — file_b's content references file_a's filename,
#      and file_a's content references file_b's filename.

resource "local_file" "file_a" {
  content  = "points to: ${local_file.file_b.filename}"
  filename = "${path.module}/file_a.txt"
}

resource "local_file" "file_b" {
  content  = "points to: ${local_file.file_a.filename}"
  filename = "${path.module}/file_b.txt"
}
