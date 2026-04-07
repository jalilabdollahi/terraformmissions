resource "local_file" "config" {
  content  = "environment=production"
  filename = "${path.module}/config.txt"
}

# BUG: local_file does not export .content as an attribute.
# Use .filename to get the path of the created file.
output "config_path" {
  value = local_file.config.content
}
