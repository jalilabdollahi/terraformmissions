# Frostbite ice-cream vans - till controller firmware rollout.

variable "firmware_version" {
  type    = string
  default = "4.2.1"
}

resource "terraform_data" "till_firmware" {
  input = var.firmware_version

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/flash.sh"

    environment = {
      VAN_ID    = "van-07"
      FIRMWARE  = var.firmware_version
      IMAGE_DIR = "${path.module}/images"
    }
  }
}

output "firmware_target" {
  value = terraform_data.till_firmware.output
}
