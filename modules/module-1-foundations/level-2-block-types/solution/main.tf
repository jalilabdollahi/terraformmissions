resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/app.conf"
}

output "config_path" {
  value = local_file.config.filename
}
