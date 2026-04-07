# Bug: a references b.filename and b references a.filename — cycle!
resource "local_file" "a" {
  content  = "file a references ${local_file.b.filename}"
  filename = "${path.module}/a.txt"
}

resource "local_file" "b" {
  content  = "file b references ${local_file.a.filename}"
  filename = "${path.module}/b.txt"
}
