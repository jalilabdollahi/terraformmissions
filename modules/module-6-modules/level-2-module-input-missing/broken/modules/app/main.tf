variable "app_name" {
  type        = string
  description = "Name of the application"
}

resource "local_file" "app" {
  content  = "app=${var.app_name}"
  filename = "${path.module}/app.txt"
}
