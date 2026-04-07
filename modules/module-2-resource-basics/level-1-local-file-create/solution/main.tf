resource "local_file" "config" {
  content  = "environment = production"
  filename = "${path.module}/config.txt"
}
