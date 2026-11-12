# Fenwick Wildlife Rescue - volunteer rota and enclosure slots.
# State is the local terraform.tfstate on the shared ops VM (no remote backend yet).

locals {
  keepers = toset(["asha", "bram", "cleo"])
  animals = toset(["otters", "owls"])
}

resource "random_uuid" "rota_epoch" {}

resource "random_id" "keeper_badge" {
  for_each    = local.keepers
  byte_length = 3
}

resource "random_integer" "enclosure_slot" {
  for_each = local.animals
  min      = 100
  max      = 400
}

# Added on Wednesday for the injured heron.
resource "random_integer" "quarantine_bay" {
  min = 1
  max = 60
}

resource "local_file" "feeding_rota" {
  filename = "${path.module}/out/feeding-rota.txt"
  content = join("\n", concat(
    ["rota ${random_uuid.rota_epoch.result}"],
    [for k in sort(keys(random_id.keeper_badge)) : "keeper ${k} badge ${random_id.keeper_badge[k].hex}"],
    [for a in sort(keys(random_integer.enclosure_slot)) : "enclosure ${a} slot ${random_integer.enclosure_slot[a].result}"],
    [""],
  ))
}

output "quarantine_bay" {
  value = random_integer.quarantine_bay.result
}
