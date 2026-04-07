data "local_file" "config" {
  filename = "${path.module}/data.txt"
}

output "config_content" {
  value = data.local_file.config.content
}
