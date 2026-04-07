# Terraform 1.5+ import block — declarative import.
# BUG: the id points to the wrong path.

import {
  to = local_file.config
  id = "/wrong/path/config.txt"
}

resource "local_file" "config" {
  content  = "configuration data"
  filename = "${path.module}/config.txt"
}
