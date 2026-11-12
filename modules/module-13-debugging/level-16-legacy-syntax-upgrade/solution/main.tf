# Ashby County Fair - programme and price board.

locals {
  stall_list = var.stalls
  extras     = ["tombola", "face painting"]
  extra_fees = { tombola = 2, "face painting" = 5 }
}

resource "local_file" "programme" {
  filename = "${path.module}/fair/programme.txt"
  content  = "${var.fair_name}\nStalls: ${join(", ", local.stall_list)}\nExtras: ${join(", ", local.extras)}\n"
}

resource "local_file" "price_board" {
  depends_on = [local_file.programme]

  filename = "${path.module}/fair/prices.txt"
  content  = "${join("\n", concat(formatlist("%s: %s", keys(var.prices), values(var.prices)), formatlist("extra %s: %s", keys(local.extra_fees), values(local.extra_fees))))}\n"
}

output "stall_count" {
  value = length(var.stalls)
}

output "extras" {
  value = local.extras
}
