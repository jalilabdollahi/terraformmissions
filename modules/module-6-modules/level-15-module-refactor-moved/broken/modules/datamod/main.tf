resource "local_file" "data" {
  content  = "module data"
  filename = "${path.module}/data.txt"
}
