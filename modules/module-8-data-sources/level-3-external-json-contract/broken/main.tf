# Dawn flight of the "Lark" hot-air balloon: a helper script totals the basket load.

data "external" "load" {
  program = ["python3", "${path.module}/bin/manifest.py"]
}

locals {
  load      = data.external.load.result
  total_kg  = tonumber(local.load.total_kg)
  max_kg    = tonumber(local.load.max_kg)
  names     = split("|", local.load.names)
  headroom  = local.max_kg - local.total_kg
}

resource "local_file" "flight_card" {
  filename = "${path.module}/out/flight-card.txt"
  content = join("\n", concat(
    ["Pilot: ${local.load.pilot}", "Passengers (${local.load.pax}):"],
    [for n in local.names : "  - ${n}"],
    ["Load: ${local.total_kg} kg of ${local.max_kg} kg (headroom ${local.headroom} kg)", ""]
  ))
}

output "total_kg" {
  value = local.total_kg
}

output "headroom_kg" {
  value = local.headroom
}

output "passenger_names" {
  value = local.names
}
