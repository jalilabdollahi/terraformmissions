-- Price list for Wax & Groove Records (used jazz and rock sleeves)

; markup is a percentage added on top of the buy-in price
variable "markup_pct" {
  type    = number
  default = 10
}

<!--
  Buy-in prices in whole pounds.
  Update these after every Saturday crate dig.
-->
locals {
  records = {
    "Kind of Blue" = 24
    "Rumours"      = 18
    "Blue Train"   = 30
  }
}

# Sorted by title because Terraform orders map keys alphabetically.
resource "local_file" "price_list" {
  filename = "${path.module}/shop/price-list.csv"
  content = join("\n", concat(
    [for title, buy in local.records : format("%s,%.2f", title, buy * (1 + var.markup_pct / 100))],
    [""]
  ))
}

output "record_count" {
  value = length(local.records)
}
