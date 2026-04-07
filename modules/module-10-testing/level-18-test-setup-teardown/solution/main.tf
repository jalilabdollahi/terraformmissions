resource "local_file" "config" {
  content  = "base config"
  filename = "${path.module}/config.txt"
}

resource "local_file" "manifest" {
  content  = "manifest data"
  filename = "${path.module}/manifest.txt"
}

output "config_path" {
  value = local_file.config.filename
}

output "manifest_path" {
  value = local_file.manifest.filename
}
