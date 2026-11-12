# Ghost train ride controller GT-114 "Crypt Express".
# A firmware release should reflash the controller: the controller record must be rebuilt from
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

resource "terraform_data" "controller" {
  input = {
    serial = "GT-114"
    ride   = "Crypt Express"
  }

  lifecycle {
    replace_triggered_by = [terraform_data.calibration]
  }
}

resource "local_file" "service_card" {
  filename = "${path.module}/service/gt-114.txt"
  content  = "controller ${terraform_data.controller.id} runs firmware ${terraform_data.firmware_pack.output}\n"
}
