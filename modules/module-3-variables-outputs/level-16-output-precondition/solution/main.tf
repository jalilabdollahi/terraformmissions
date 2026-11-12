# Acetaia Bruna vinegar loft — shop label feed.
# The online shop reads `shop_label` and sells whatever it says. Nothing may be
# published for a barrel that has not aged for at least `min_ageing_days`
# (last month a 28-day barrel was sold as "mature" because the number was never checked).

variable "barrel_name" {
  type    = string
  default = "Modena Reserve"
}

variable "ageing_days" {
  description = "Days this barrel has spent ageing in the loft."
  type        = number
  default     = 75
}

variable "min_ageing_days" {
  description = "Minimum ageing (days) before a barrel may be offered for sale."
  type        = number
  default     = 60
}

locals {
  label = "${var.barrel_name}, aged ${var.ageing_days} days"
}

resource "local_file" "label_feed" {
  filename = "${path.module}/shop/label.txt"
  content  = "${local.label}\n"
}

output "shop_label" {
  description = "The label published to the online shop."
  value       = local.label

  precondition {
    condition     = var.ageing_days >= var.min_ageing_days
    error_message = "Refusing to publish: this barrel has aged ${var.ageing_days} days, the minimum is ${var.min_ageing_days}."
  }
}
