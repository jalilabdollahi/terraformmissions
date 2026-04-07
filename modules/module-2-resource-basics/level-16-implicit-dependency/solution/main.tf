resource "local_file" "first" {
  content  = "primary config"
  filename = "${path.module}/primary.txt"
}

resource "local_file" "second" {
  content  = "secondary config references: ${local_file.first.filename}"
  filename = "${path.module}/secondary.txt"
}
