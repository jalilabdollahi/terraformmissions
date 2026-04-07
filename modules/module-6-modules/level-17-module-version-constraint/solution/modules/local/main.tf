resource "local_file" "data" {
  content  = "local module content"
  filename = "${path.module}/data.txt"
}

output "file_path" {
  value = local_file.data.filename
}
