# BUG: nonexistent_attr is not an attribute of local_file.
# ignore_changes must reference valid attributes of the resource.

resource "local_file" "app_config" {
  content  = "config_version=1"
  filename = "${path.module}/app.conf"

  lifecycle {
    ignore_changes = [nonexistent_attr]
  }
}
