# Fenwick Lantern Parade Volunteers - build rota and workshop bench slots.
# State is the local terraform.tfstate on the shared ops VM (no remote backend yet).

locals {
  stewards = toset(["asha", "bram", "cleo"])
  designs = toset(["otters", "owls"])
}

resource "random_uuid" "rota_epoch" {}

resource "random_id" "steward_badge" {
  for_each    = local.stewards
  byte_length = 3
}

resource "random_integer" "bench_slot" {
  for_each = local.designs
  min      = 100
  max      = 400
}

# Added on Wednesday for the storm-damaged heron lantern.
resource "random_integer" "repair_rack" {
  min = 1
  max = 60
}

resource "local_file" "build_rota" {
  filename = "${path.module}/out/build-rota.txt"
  content = join("\n", concat(
    ["rota ${random_uuid.rota_epoch.result}"],
    [for k in sort(keys(random_id.steward_badge)) : "steward ${k} badge ${random_id.steward_badge[k].hex}"],
    [for a in sort(keys(random_integer.bench_slot)) : "bench ${a} slot ${random_integer.bench_slot[a].result}"],
    [""],
  ))
}

output "repair_rack" {
  value = random_integer.repair_rack.result
}
