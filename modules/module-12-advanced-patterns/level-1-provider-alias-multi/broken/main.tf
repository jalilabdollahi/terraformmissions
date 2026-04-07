provider "local" {
  alias = "primary"
}

provider "local" {
  alias = "secondary"
}

# Bug: references a non-existent alias "wrong"
resource "local_file" "config" {
  provider = local.wrong

  content  = "primary config"
  filename = "${path.module}/config.txt"
}
