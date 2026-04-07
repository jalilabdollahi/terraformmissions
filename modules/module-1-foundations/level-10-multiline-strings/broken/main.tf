resource "local_file" "script" {
  content  = "#!/bin/bash
echo hello world"
  filename = "${path.module}/hello.sh"
}
