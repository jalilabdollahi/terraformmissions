variable "db_password" {
  type      = string
  sensitive = true
  default   = "fallback-password"
}

resource "local_file" "config" {
  content  = "password=${var.db_password}"
  filename = "${path.module}/app.conf"
}
