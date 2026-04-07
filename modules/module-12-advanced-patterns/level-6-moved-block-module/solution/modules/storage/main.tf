resource "local_file" "config" {
  content  = "stored config"
  filename = "${path.module}/config.txt"
}
