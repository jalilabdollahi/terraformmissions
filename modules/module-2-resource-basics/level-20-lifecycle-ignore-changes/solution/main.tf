resource "local_file" "app_config" {
  content  = "config_version=1"
  filename = "${path.module}/app.conf"

  lifecycle {
    ignore_changes = [content]
  }
}
