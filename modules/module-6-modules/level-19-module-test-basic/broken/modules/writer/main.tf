resource "local_file" "output" {
  content  = "test output"
  filename = "${path.module}/output.txt"
}

output "file_path" {
  value = local_file.output.filename
}
