resource "local_file" "first" {
  content  = "first file"
  filename = "${path.module}/first.txt"
}

# Bug: file_permission "999" is not a valid octal permission string
resource "local_file" "second" {
  content         = "second file"
  filename        = "${path.module}/second.txt"
  file_permission = "999"
}
