# Radio Pinewood transmitter settings, loaded from env/<workspace>.yaml.

locals {
  settings = file("${path.module}/env/${terraform.workspace}.yaml")
}

resource "local_file" "transmitter" {
  filename = "${path.module}/out/${terraform.workspace}-transmitter.conf"
  content  = "frequency_mhz=${local.settings.frequency_mhz}\npower_watts=${local.settings.power_watts}\n"
}

output "frequency" {
  value = local.settings.frequency_mhz
}

output "power_watts" {
  value = local.settings.power_watts
}
