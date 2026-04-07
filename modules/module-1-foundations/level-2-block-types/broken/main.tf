resource "local_file" "config" {
  content  = "app_env=production"
  filename = "${path.module}/app.conf"
}

# Wrong keyword: "outputs" should be "output"
outputs "config_path" {
  value = local_file.config.filename
}
