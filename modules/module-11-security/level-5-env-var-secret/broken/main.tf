# Variable name uses uppercase — env var TF_VAR_db_password won't map to this
variable "DB_PASSWORD" {
  type      = string
  sensitive = true
  default   = "fallback-password"
}

resource "local_file" "config" {
  content  = "password=${var.DB_PASSWORD}"
  filename = "${path.module}/app.conf"
}
