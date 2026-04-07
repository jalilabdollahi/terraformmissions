import {
  to = local_file.config
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "configuration data"
  filename = "${path.module}/config.txt"
}
