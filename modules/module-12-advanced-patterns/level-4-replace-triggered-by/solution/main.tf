resource "null_resource" "trigger" {
  triggers = {
    version = "v1"
  }
}

resource "local_file" "config" {
  content  = "triggered config"
  filename = "${path.module}/config.txt"

  lifecycle {
    replace_triggered_by = [null_resource.trigger]
  }
}
