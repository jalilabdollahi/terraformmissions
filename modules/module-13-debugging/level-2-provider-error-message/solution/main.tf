resource "local_file" "config" {
  content         = "permission test"
  filename        = "${path.module}/config.txt"
  file_permission = "0644"
}
