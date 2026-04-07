data "local_file" "maybe" {
  filename = "${path.module}/maybe_exists.txt"
}

locals {
  file_content = try(data.local_file.maybe.content, "default content")
}

resource "local_file" "result" {
  content  = local.file_content
  filename = "${path.module}/result.txt"
}
