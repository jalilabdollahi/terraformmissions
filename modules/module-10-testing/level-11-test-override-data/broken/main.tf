data "local_file" "settings" {
  filename = "${path.module}/settings.txt"
}

output "settings_content" {
  value = data.local_file.settings.content
}
