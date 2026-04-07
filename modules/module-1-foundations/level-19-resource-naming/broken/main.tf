# Resource names must start with a letter or underscore, not a digit.

resource "local_file" "1_config" {
  content  = "version=1"
  filename = "${path.module}/config.txt"
}
