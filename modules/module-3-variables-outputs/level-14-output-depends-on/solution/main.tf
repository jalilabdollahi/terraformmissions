resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value      = local_file.config.filename
  depends_on = [local_file.config]
}
