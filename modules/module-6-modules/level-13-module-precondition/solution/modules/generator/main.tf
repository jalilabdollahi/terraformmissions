variable "item_count" {
  type    = number
  default = 1
}

resource "local_file" "items" {
  lifecycle {
    precondition {
      condition     = var.item_count > 0
      error_message = "item_count must be greater than 0."
    }
  }
  content  = "items: ${var.item_count}"
  filename = "${path.module}/items.txt"
}
