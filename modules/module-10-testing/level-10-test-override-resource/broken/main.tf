resource "local_file" "config" {
  content  = "production config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename
}
