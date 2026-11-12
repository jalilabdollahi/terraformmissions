# Daily bake sheet for the Corner Crumb bakery.
# The shop manager prints everything under out/ and pins it by the ovens.

locals {
  bakes = {
    sourdough = 24
    rye       = 12
    focaccia  = 18
  }
  sheet_lines = [for name, qty in local.bakes : "${format("%-10s", name)} x ${qty}"]
}

resource "local_file" "bake_sheet" {
  filename = "${path.module}/bake-sheet.txt"
  content  = "BAKE SHEET\n${join("\n", local.sheet_lines)}\n"
}

resource "local_file" "price_labels" {
  filename = "${path.module}/out/price-labels.txt"
  content  = "sourdough 4.50\nrye 5.25\nfocaccia 3.75\n"
}

output "bake_sheet_path" {
  value = local_file.bake_sheet.filename
}

output "total_loaves" {
  value = sum(values(local.bakes))
}
