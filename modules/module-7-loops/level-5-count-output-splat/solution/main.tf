resource "local_file" "config" {
  count    = 3
  content  = "config ${count.index}"
  filename = "${path.module}/config-${count.index}.txt"
}

output "all_filenames" {
  value = local_file.config[*].filename
}
