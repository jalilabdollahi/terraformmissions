resource "local_file" "config" {
  count    = 3
  content  = "config instance ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}
