resource "local_file" "app_config" {
  content         = "app_version=1.0.0"
  filename        = "${path.module}/app.cfg"
  file_permission = "0600"

  # Bug: ignore_changes = all prevents ANY drift from being detected,
  # including critical changes to file_permission
  lifecycle {
    ignore_changes = all
  }
}
