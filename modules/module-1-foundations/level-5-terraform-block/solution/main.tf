resource "local_file" "hosts" {
  content  = "127.0.0.1 localhost"
  filename = "${path.module}/hosts.txt"
}
