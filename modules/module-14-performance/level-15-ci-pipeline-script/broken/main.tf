# Quillfeather Optics: lens order sheets.

variable "orders" {
  type = map(object({
    sphere   = number
    cylinder = number
    coating  = string
  }))
  default = {
    "ord-7001" = { sphere = -2.25, cylinder = -0.50, coating = "anti-glare" }
    "ord-7002" = { sphere = 1.00, cylinder = 0.00, coating = "blue-cut" }
    "ord-7003" = { sphere = -4.75, cylinder = -1.25, coating = "scratch-guard" }
  }
}

resource "local_file" "order_sheet" {
  for_each = var.orders
  filename = "${path.module}/orders/${each.key}.txt"
  content  = "${each.key}: sphere ${each.value.sphere}, cylinder ${each.value.cylinder}, coating ${each.value.coating}\n"
}
