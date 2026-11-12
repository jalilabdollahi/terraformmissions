# Pinewood Mobile mast settings, loaded from env/<workspace>.yaml.

locals {
  settings = file("${path.module}/env/${terraform.workspace}.yaml")
}

resource "local_file" "mast" {
  filename = "${path.module}/out/${terraform.workspace}-mast.conf"
  content  = "carrier_mhz=${local.settings.carrier_mhz}\npower_watts=${local.settings.power_watts}\n"
}

output "carrier" {
  value = local.settings.carrier_mhz
}

output "power_watts" {
  value = local.settings.power_watts
}
