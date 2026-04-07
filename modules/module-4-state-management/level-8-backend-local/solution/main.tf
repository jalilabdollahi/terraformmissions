resource "local_file" "readme" {
  content  = "Hello from state level 8"
  filename = "${path.module}/readme.txt"
}
