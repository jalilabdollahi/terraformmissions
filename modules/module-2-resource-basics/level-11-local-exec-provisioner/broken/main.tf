# Release stamp for the Inkwell Press print shop's template bundle.
# After the bundle is "released", a local-exec step drops a RELEASE file into
# dist/ so the print-server's cron job knows which version is live.

variable "release" {
  type    = string
  default = "2024.3-rc1"
}

resource "null_resource" "stamp_release" {
  provisioner "local-exec" {
    interpreter = ["bash"]
    working_dir = "${path.module}/dist"
    command     = "mkdir -p dist && printf 'release=%s\\n' \"$RELEASE\" > dist/RELEASE"

    environment = {
      RELEASE = var.release
    }
  }
}

output "stamp_resource_id" {
  value = null_resource.stamp_release.id
}
