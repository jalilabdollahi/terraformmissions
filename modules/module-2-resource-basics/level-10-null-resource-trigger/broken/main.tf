# BUG: triggers values must be strings. The number 1 must be quoted.

resource "null_resource" "deploy" {
  triggers = {
    version = 1
  }
}
