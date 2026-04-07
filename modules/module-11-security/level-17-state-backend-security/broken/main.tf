resource "local_file" "readme" {
  content  = "This config demonstrates backend credential security."
  filename = "${path.module}/README.txt"
}
