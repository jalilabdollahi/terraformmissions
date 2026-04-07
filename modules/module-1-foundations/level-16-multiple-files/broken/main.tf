# main.tf references var.environment, but variables.tf is missing.

resource "local_file" "env_config" {
  content  = "ENVIRONMENT=${var.environment}\nDEBUG=${var.debug}"
  filename = "${path.module}/app.env"
}

output "config_file" {
  value = local_file.env_config.filename
}
