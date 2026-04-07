resource "local_file" "output" {
  content  = "module output data"
  filename = "${path.module}/output.txt"
}

output "file_path" {
  value = local_file.output.filename
}
