variable "app" {
  type    = string
  default = "myapp"
}

# BUG: the vars map uses key "name" but the template expects "${app_name}"
resource "local_file" "rendered" {
  content  = templatefile("${path.module}/app.tpl", { name = var.app })
  filename = "${path.module}/rendered.txt"
}
