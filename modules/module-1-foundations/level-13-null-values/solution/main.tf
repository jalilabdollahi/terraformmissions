variable "app_name" {
  type     = string
  nullable = false
  default  = "myapp"
}

resource "local_file" "app_config" {
  content  = "app=${var.app_name}"
  filename = "${path.module}/app.conf"
}
