# The data source points to the wrong filename.
# Fix: change "missing.txt" to "data.txt"

data "local_file" "config" {
  filename = "${path.module}/missing.txt"
}

output "config_content" {
  value = data.local_file.config.content
}
