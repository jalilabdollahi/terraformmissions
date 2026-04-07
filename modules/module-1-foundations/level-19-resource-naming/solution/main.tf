resource "local_file" "v1_config" {
  content  = "version=1"
  filename = "${path.module}/config.txt"
}
