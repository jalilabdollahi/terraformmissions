# Bug: id is a number (12345) — import id must always be a string
import {
  to = local_file.config
  id = 12345
}

resource "local_file" "config" {
  content  = "imported content"
  filename = "${path.module}/config.txt"
}
