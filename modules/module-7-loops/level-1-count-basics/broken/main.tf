# All three instances share the same filename — only one file would survive.
resource "local_file" "config" {
  count    = 3
  content  = "config instance"
  filename = "${path.module}/config.txt"
}
