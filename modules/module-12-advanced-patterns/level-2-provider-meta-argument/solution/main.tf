provider "local" {
  alias = "primary"
}

resource "local_file" "app_config" {
  provider = local.primary

  content  = "environment=production"
  filename = "${path.module}/app.cfg"
}
