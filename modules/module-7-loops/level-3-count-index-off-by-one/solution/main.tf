resource "local_file" "files" {
  count    = 3
  content  = "file content ${count.index}"
  filename = "${path.module}/file-${count.index}.txt"
}

output "file_names" {
  value = local_file.files[*].filename
}
