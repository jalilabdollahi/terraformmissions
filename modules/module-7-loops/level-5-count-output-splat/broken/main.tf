resource "local_file" "config" {
  count    = 3
  content  = "config ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

# Wrong: count resource can't be referenced without [*] or [N]
output "all_filenames" {
  value = local_file.config.filename
}
