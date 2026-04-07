resource "local_file" "data" {
  content  = "refresh-only demo"
  filename = "${path.module}/data.txt"
}

# BUG: local_file has no exported attribute "size"
output "file_info" {
  value = local_file.data.size
}
