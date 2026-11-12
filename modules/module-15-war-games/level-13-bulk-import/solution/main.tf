# Alderwater flood-warning network - gauge adoption.
#
# Terraform has only ever managed the network key. The river gauges were registered by hand
# years ago; their serial numbers (the random_id values printed on the gauge housings) sit in
# register/gauges.json, exported nightly from the asset database. This file is the first
# attempt to bring them under management.

locals {
  register = jsondecode(file("${path.module}/register/gauges.json"))
  # Retired gauges stay out of Terraform.
  gauges = { for g in local.register.stations : g.station => g if g.status == "active" }
}

resource "random_id" "network_key" {
  byte_length = 8
}

resource "random_id" "gauge" {
  for_each = local.gauges
  # base64url packs 3 bytes into 4 characters: the serial length gives the byte length.
  byte_length = floor(length(each.value.serial) * 3 / 4)
}

import {
  for_each = local.gauges
  to       = random_id.gauge[each.key]
  id       = each.value.serial
}

resource "local_file" "gauge_roster" {
  filename = "${path.module}/out/gauge-roster.txt"
  content = join("\n", concat(
    ["network key ${random_id.network_key.hex}"],
    [for k in sort(keys(random_id.gauge)) : "gauge ${k} ${random_id.gauge[k].hex}"],
    [""],
  ))
}

output "gauge_count" {
  value = length(random_id.gauge)
}
