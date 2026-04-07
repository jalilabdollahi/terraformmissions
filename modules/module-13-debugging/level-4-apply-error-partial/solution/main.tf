resource "local_file" "first" {
  content  = "first file"
  filename = "${path.module}/first.txt"
}

resource "local_file" "second" {
  content         = "second file"
  filename        = "${path.module}/second.txt"
  file_permission = "0644"
}
