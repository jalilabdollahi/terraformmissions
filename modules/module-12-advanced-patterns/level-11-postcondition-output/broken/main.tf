resource "local_file" "config" {
  content  = "app config"
  filename = "${path.module}/config.txt"
}

output "config_path" {
  value = local_file.config.filename

  # Bug: self.wrong_attr does not exist; should be self.value
  lifecycle {
    postcondition {
      condition     = self.wrong_attr != ""
      error_message = "Config path must not be empty."
    }
  }
}
