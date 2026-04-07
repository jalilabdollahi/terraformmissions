resource "local_file" "app_config" {
  content         = "app_version=1.0.0"
  filename        = "${path.module}/app.cfg"
  file_permission = "0600"

  lifecycle {
    ignore_changes = [content]
  }
}
