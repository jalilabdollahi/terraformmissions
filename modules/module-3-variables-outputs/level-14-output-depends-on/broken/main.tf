resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/config.txt"
}

# BUG: depends_on references a resource that doesn't exist.
output "config_path" {
  value      = local_file.config.filename
  depends_on = [local_file.nonexistent]
}
