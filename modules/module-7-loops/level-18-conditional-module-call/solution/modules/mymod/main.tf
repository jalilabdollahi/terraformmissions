resource "local_file" "result" {
  content  = "module result"
  filename = "${path.module}/result.txt"
}

output "file_path" {
  value = local_file.result.filename
}
