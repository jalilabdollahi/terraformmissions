variable "config_path" {
  type        = string
  description = "Path to the config file"
}

resource "local_file" "app" {
  content  = "app config: ${var.config_path}"
  filename = "${path.module}/app.txt"
}
