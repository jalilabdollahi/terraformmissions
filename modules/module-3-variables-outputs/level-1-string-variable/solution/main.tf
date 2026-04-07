variable "app_name" {
  type    = string
  default = "hello"
}

resource "local_file" "info" {
  content  = var.app_name
  filename = "${path.module}/info.txt"
}
