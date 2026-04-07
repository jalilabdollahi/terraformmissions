variable "app" {
  type    = string
  default = "myapp"
}

resource "local_file" "rendered" {
  content  = templatefile("${path.module}/app.tpl", { app_name = var.app })
  filename = "${path.module}/rendered.txt"
}
