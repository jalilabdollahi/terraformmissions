# The data source reads a file that is created by local_file.writer,
# but there is no depends_on, so ordering is not guaranteed.
# Fix: add depends_on = [local_file.writer] to the data source.

resource "local_file" "writer" {
  content  = "written by terraform"
  filename = "${path.module}/output.txt"
}

data "local_file" "output" {
  filename = "${path.module}/output.txt"
}

output "file_content" {
  value = data.local_file.output.content
}
