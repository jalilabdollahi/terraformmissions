variable "item_count" {
  type    = number
  default = 1
}

resource "local_file" "items" {
  # Precondition requires count > 10 — but default is 1, so this always fails.
  lifecycle {
    precondition {
      condition     = var.item_count > 10
      error_message = "item_count must be greater than 10."
    }
  }
  content  = "items: ${var.item_count}"
  filename = "${path.module}/items.txt"
}
