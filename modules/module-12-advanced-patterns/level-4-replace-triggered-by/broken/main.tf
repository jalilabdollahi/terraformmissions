resource "null_resource" "trigger" {
  triggers = {
    version = "v1"
  }
}

# Bug: references null_resource.wrong_ref which does not exist
resource "local_file" "config" {
  content  = "triggered config"
  filename = "${path.module}/config.txt"

  lifecycle {
    replace_triggered_by = [null_resource.wrong_ref]
  }
}
