# A null_resource with a trigger. The application version was bumped to v2
# but someone forgot to update the trigger — so Terraform doesn't know it
# needs to replace the resource.
# BUG: trigger is still "v1" but should be "v2"

resource "null_resource" "task" {
  triggers = {
    version = "v1"
  }

  provisioner "local-exec" {
    command = "echo Task running at version v2"
  }
}
