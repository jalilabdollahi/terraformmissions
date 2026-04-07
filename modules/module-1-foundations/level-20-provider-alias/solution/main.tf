provider "local" {
  alias = "primary"
}

resource "local_file" "config" {
  content  = "primary config"
  filename = "${path.module}/config.txt"

  provider = local.primary
}
