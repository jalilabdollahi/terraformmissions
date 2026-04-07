variable "file_content" {
  type    = string
  default = "initial content"
}

# BUG: content uses wrong variable reference (trailing 's')
resource "local_file" "tracked" {
  content  = var.file_contents
  filename = "${path.module}/tracked.txt"
}
