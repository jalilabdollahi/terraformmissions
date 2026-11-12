# Alderwater defibrillator cabinet network - cabinet adoption.
#
# Terraform has only ever managed the network key. The defibrillator cabinets were registered by hand
# years ago; their serial numbers (the random_id values printed on the cabinet door labels) sit in
# register/cabinets.json, exported nightly from the asset database. This file is the first
# attempt to bring them under management.

locals {
  register = jsondecode(file("${path.module}/register/cabinets.json"))
  cabinets = { for g in local.register.sites : g.site => g }
}

resource "random_id" "network_key" {
  byte_length = 8
}

resource "random_id" "cabinet" {
  for_each    = local.cabinets
  byte_length = 6
}

resource "local_file" "cabinet_roster" {
  filename = "${path.module}/out/cabinet-roster.txt"
  content = join("\n", concat(
    ["network key ${random_id.network_key.hex}"],
    [for k in sort(keys(random_id.cabinet)) : "cabinet ${k} ${random_id.cabinet[k].hex}"],
    [""],
  ))
}

output "cabinet_count" {
  value = length(random_id.cabinet)
}
