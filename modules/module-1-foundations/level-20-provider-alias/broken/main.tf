# Two local provider instances with different path prefixes
provider "local" {
  alias = "primary"
}

resource "local_file" "config" {
  content  = "primary config"
  filename = "${path.module}/config.txt"

  provider = local.secondary   # Wrong: alias "secondary" was never declared
}
