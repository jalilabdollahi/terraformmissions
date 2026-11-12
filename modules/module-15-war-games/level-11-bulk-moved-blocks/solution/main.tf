# Nordhavn hub register, after the "stop using count" refactor (PR #212).
#
# The refactor merged on Friday. Everything below is the NEW shape of the code; the
# running hub was built from the old, count-indexed version. The old order of the
# loaders, ramp stands and dock doors is recorded in out/ramp-manifest.txt, which the
# last apply wrote.

locals {
  loader_lines = [for n in var.loaders : "loader ${n} ${random_id.loader[n].hex}"]
  stand_lines  = [for n in var.stands : "stand ${n} ${random_integer.stand[n].result}"]
  dock_lines  = [for n in var.dock_doors : "dock ${n} ${terraform_data.dock[n].id}"]
}

resource "random_id" "loader" {
  for_each    = toset(var.loaders)
  byte_length = 4
}

resource "random_integer" "stand" {
  for_each = toset(var.stands)
  min      = 1000
  max      = 9999
}

resource "terraform_data" "dock" {
  for_each = toset(var.dock_doors)
  input    = each.key
}

resource "random_uuid" "hub_licence" {}

resource "time_static" "opening" {}

resource "local_file" "ramp_manifest" {
  filename = "${path.module}/out/ramp-manifest.txt"
  content = join("\n", concat(
    ["licence ${random_uuid.hub_licence.result}", "opening ${time_static.opening.rfc3339}"],
    sort(local.loader_lines),
    sort(local.stand_lines),
    sort(local.dock_lines),
    [""],
  ))
}

output "ramp_manifest_path" {
  value = local_file.ramp_manifest.filename
}
