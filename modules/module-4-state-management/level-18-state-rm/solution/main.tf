resource "local_file" "config" {
  content  = "state rm demo"
  filename = "${path.module}/config.txt"
}
