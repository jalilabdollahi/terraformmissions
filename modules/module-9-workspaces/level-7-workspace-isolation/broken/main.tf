# Both workspaces would write to the same "app.conf" file.
# Fix: add the workspace name to the filename to keep workspaces isolated.
# Change filename to "${path.module}/app-${terraform.workspace}.conf"

resource "local_file" "app_config" {
  content  = "env=${terraform.workspace}"
  filename = "${path.module}/app.conf"
}

output "config_path" {
  value = local_file.app_config.filename
}
