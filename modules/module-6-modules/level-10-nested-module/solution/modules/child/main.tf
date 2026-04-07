resource "local_file" "config" {
  content  = "generated config"
  filename = "${path.module}/child-config.txt"
}
