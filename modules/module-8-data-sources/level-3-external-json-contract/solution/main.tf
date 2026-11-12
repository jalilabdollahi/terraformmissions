# Gorge bungee jump: a helper script totals the jumpers' weights for the jump card.

data "external" "load" {
  program = ["python3", "${path.module}/bin/weigh_in.py"]
}

locals {
  load      = data.external.load.result
  total_kg  = tonumber(local.load.total_kg)
  max_kg    = tonumber(local.load.max_kg)
  names     = split("|", local.load.names)
  headroom  = local.max_kg - local.total_kg
}

resource "local_file" "jump_card" {
  filename = "${path.module}/out/jump-card.txt"
  content = join("\n", concat(
    ["Jump master: ${local.load.master}", "Jumpers (${local.load.jumpers}):"],
    [for n in local.names : "  - ${n}"],
    ["Weight: ${local.total_kg} kg of ${local.max_kg} kg (headroom ${local.headroom} kg)", ""]
  ))
}

output "total_kg" {
  value = local.total_kg
}

output "headroom_kg" {
  value = local.headroom
}

output "jumper_names" {
  value = local.names
}
