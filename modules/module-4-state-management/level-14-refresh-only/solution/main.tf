resource "local_file" "data" {
  content  = "refresh-only demo"
  filename = "${path.module}/data.txt"
}

output "file_info" {
  value = local_file.data.filename
}
