# This data source will fail if the file doesn't exist
data "local_file" "maybe" {
  filename = "${path.module}/maybe_exists.txt"
}

# Bug: directly accessing data source content without handling the case where it fails
locals {
  file_content = data.local_file.maybe.content
}

resource "local_file" "result" {
  content  = local.file_content
  filename = "${path.module}/result.txt"
}
