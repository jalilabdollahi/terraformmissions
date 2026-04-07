resource "null_resource" "task" {
  triggers = {
    version = "v2"
  }

  provisioner "local-exec" {
    command = "echo Task running at version v2"
  }
}
