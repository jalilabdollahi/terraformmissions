resource "local_file" "data" {
  content  = "module data"
  filename = "${path.module}/data.txt"
}

output "file_path" {
  value = local_file.data.filename
}
