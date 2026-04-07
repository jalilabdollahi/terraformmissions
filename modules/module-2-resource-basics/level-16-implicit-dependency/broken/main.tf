resource "local_file" "first" {
  content  = "primary config"
  filename = "${path.module}/primary.txt"
}

# BUG: local_file does not have a .path attribute. Use .filename instead.
resource "local_file" "second" {
  content  = "secondary config references: ${local_file.first.path}"
  filename = "${path.module}/secondary.txt"
}
