# Bug: to = module.storage.local_file.config references a non-existent module
import {
  to = module.storage.local_file.config
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "imported content"
  filename = "${path.module}/config.txt"
}
