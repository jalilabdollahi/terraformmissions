resource "local_file" "config" {
  content  = "environment=production"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
