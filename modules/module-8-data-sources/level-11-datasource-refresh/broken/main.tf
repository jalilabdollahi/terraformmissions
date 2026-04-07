# The data source attribute used is wrong — content_base64 instead of content.
# Fix: change data.local_file.reader.content_base64 to data.local_file.reader.content

resource "local_file" "writer" {
  content  = "v1 content"
  filename = "${path.module}/shared.txt"
}

data "local_file" "reader" {
  filename   = "${path.module}/shared.txt"
  depends_on = [local_file.writer]
}

output "file_text" {
  value = data.local_file.reader.content_base64
}
