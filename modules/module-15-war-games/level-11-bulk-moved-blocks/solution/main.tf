# Nordhavn auction house register, after the "stop using count" refactor (PR #212).
#
# The refactor merged on Friday. Everything below is the NEW shape of the code; the
# running auction house was built from the old, count-indexed version. The old order of the
# carts, auction lots and dock doors is recorded in out/lot-manifest.txt, which the
# last apply wrote.

locals {
  cart_lines = [for n in var.carts : "cart ${n} ${random_id.cart[n].hex}"]
  lot_lines  = [for n in var.lots : "lot ${n} ${random_integer.lot[n].result}"]
  dock_lines  = [for n in var.dock_doors : "dock ${n} ${terraform_data.dock[n].id}"]
}

resource "random_id" "cart" {
  for_each    = toset(var.carts)
  byte_length = 4
}

resource "random_integer" "lot" {
  for_each = toset(var.lots)
  min      = 1000
  max      = 9999
}

resource "terraform_data" "dock" {
  for_each = toset(var.dock_doors)
  input    = each.key
}

resource "random_uuid" "house_licence" {}

resource "time_static" "opening" {}

resource "local_file" "lot_manifest" {
  filename = "${path.module}/out/lot-manifest.txt"
  content = join("\n", concat(
    ["licence ${random_uuid.house_licence.result}", "opening ${time_static.opening.rfc3339}"],
    sort(local.cart_lines),
    sort(local.lot_lines),
    sort(local.dock_lines),
    [""],
  ))
}

output "lot_manifest_path" {
  value = local_file.lot_manifest.filename
}
