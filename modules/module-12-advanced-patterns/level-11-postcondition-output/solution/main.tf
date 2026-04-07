resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename

  lifecycle {
    postcondition {
      condition     = self.value != ""
      error_message = "Config path must not be empty."
    }
  }
}
