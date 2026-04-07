# Bug: 'to' references local_file.wrong_resource which is not declared
import {
  to = local_file.wrong_resource
  id = "${path.module}/config.txt"
}

resource "local_file" "config" {
  content  = "imported config"
  filename = "${path.module}/config.txt"
}
