variable "file_content" {
  type    = string
  default = "initial content"
}

resource "local_file" "tracked" {
  content  = var.file_content
  filename = "${path.module}/tracked.txt"
}
