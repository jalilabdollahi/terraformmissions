locals {
  loader_lines = [for i, n in var.loaders : "loader ${n} ${random_id.loader_serial[i].hex}"]
  stand_lines  = [for i, n in var.stands : "stand ${n} ${random_integer.stand_slot[i].result}"]
  dock_lines  = [for i, n in var.dock_doors : "dock ${n} ${terraform_data.dock_door[i].id}"]
}

resource "random_id" "loader_serial" {
  count       = length(var.loaders)
  byte_length = 4
}

resource "random_integer" "stand_slot" {
  count = length(var.stands)
  min   = 1000
  max   = 9999
}

resource "terraform_data" "dock_door" {
  count = length(var.dock_doors)
  input = var.dock_doors[count.index]
}

resource "random_uuid" "ops_licence" {}

resource "time_static" "go_live" {}

resource "local_file" "ramp_manifest" {
  filename = "${path.module}/out/ramp-manifest.txt"
  content = join("\n", concat(
    ["licence ${random_uuid.ops_licence.result}", "opening ${time_static.go_live.rfc3339}"],
    sort(local.loader_lines),
    sort(local.stand_lines),
    sort(local.dock_lines),
    [""],
  ))
}

output "ramp_manifest_path" {
  value = local_file.ramp_manifest.filename
}
