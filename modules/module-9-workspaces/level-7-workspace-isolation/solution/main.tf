resource "local_file" "app_config" {
  content  = "env=${terraform.workspace}"
  filename = "${path.module}/app-${terraform.workspace}.conf"
}

output "config_path" {
  value = local_file.app_config.filename
}
