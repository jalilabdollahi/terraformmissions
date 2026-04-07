provider "local" {
  alias = "primary"
}

# Bug: provider value is a string, not a reference
resource "local_file" "app_config" {
  provider = "local.primary"

  content  = "environment=production"
  filename = "${path.module}/app.cfg"
}
