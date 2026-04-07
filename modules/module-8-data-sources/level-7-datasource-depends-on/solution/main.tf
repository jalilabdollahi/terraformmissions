resource "local_file" "writer" {
  content  = "written by terraform"
  filename = "${path.module}/output.txt"
}

data "local_file" "output" {
  filename   = "${path.module}/output.txt"
  depends_on = [local_file.writer]
}

output "file_content" {
  value = data.local_file.output.content
}
