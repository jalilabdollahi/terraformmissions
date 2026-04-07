# The 'local_file' resource uses 'file_content' which is not a valid argument.
# The correct argument name is 'content'.
resource "local_file" "output" {
  file_content = "module output data"
  filename     = "${path.module}/output.txt"
}
