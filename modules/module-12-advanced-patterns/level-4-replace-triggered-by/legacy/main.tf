# Pinball cabinet PB-114 "Atomic Gorilla".
# A firmware release should reflash the cabinet: the cabinet record must be rebuilt from
# scratch (new ID) whenever the firmware pack changes. Calibration is just a setting and
# must never trigger a rebuild.

variable "firmware" {
  type    = string
  default = "3.1"
}

variable "calibration" {
  type    = string
  default = "standard"
}

resource "terraform_data" "firmware_pack" {
  input = var.firmware
}

resource "terraform_data" "calibration" {
  input = var.calibration
}

resource "terraform_data" "cabinet" {
  input = {
    serial = "PB-114"
    game   = "Atomic Gorilla"
  }

  lifecycle {
    replace_triggered_by = [terraform_data.calibration]
  }
}

resource "local_file" "service_card" {
  filename = "${path.module}/service/pb-114.txt"
  content  = "cabinet ${terraform_data.cabinet.id} runs firmware ${terraform_data.firmware_pack.output}\n"
}
