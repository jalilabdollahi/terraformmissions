resource "local_file" "data" {
  content  = "important data"
  filename = "${path.module}/data.txt"
}

output "file_id" {
  value = local_file.data.id
}
