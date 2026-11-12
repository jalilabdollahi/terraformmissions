locals {
  cart_lines = [for i, n in var.carts : "cart ${n} ${random_id.cart_serial[i].hex}"]
  lot_lines  = [for i, n in var.lots : "lot ${n} ${random_integer.lot_slot[i].result}"]
  dock_lines  = [for i, n in var.dock_doors : "dock ${n} ${terraform_data.dock_door[i].id}"]
}

resource "random_id" "cart_serial" {
  count       = length(var.carts)
  byte_length = 4
}

resource "random_integer" "lot_slot" {
  count = length(var.lots)
  min   = 1000
  max   = 9999
}

resource "terraform_data" "dock_door" {
  count = length(var.dock_doors)
  input = var.dock_doors[count.index]
}

resource "random_uuid" "ops_licence" {}

resource "time_static" "go_live" {}

resource "local_file" "lot_manifest" {
  filename = "${path.module}/out/lot-manifest.txt"
  content = join("\n", concat(
    ["licence ${random_uuid.ops_licence.result}", "opening ${time_static.go_live.rfc3339}"],
    sort(local.cart_lines),
    sort(local.lot_lines),
    sort(local.dock_lines),
    [""],
  ))
}

output "lot_manifest_path" {
  value = local_file.lot_manifest.filename
}
