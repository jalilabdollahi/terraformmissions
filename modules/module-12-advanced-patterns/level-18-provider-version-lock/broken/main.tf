resource "local_file" "config" {
  content  = "lock file test"
  filename = "${path.module}/config.txt"
}
