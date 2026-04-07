import {
  to = local_file.config
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "imported config"
  filename = "${path.module}/config.txt"
}
