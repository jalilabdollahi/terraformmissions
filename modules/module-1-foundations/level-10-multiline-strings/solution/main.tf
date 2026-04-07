resource "local_file" "script" {
  content  = <<-EOF
    #!/bin/bash
    echo hello world
  EOF
  filename = "${path.module}/hello.sh"
}
