provider "local" {
  alias = "primary"
}

provider "local" {
  alias = "secondary"
}

resource "local_file" "config" {
  provider = local.primary

  content  = "primary config"
  filename = "${path.module}/config.txt"
}
