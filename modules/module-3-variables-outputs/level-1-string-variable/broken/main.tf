# BUG: type = number but default = "hello" (a string). These conflict.

variable "app_name" {
  type    = number
  default = "hello"
}

resource "local_file" "info" {
  content  = var.app_name
  filename = "${path.module}/info.txt"
}
