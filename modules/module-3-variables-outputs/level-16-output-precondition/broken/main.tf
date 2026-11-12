# Grotte Verte cheese cave — shop label feed.
# The online shop reads `shop_label` and sells whatever it says. Nothing may be
# published for a wheel that has not matured for at least `min_affinage_days`
# (last month a 28-day wheel was sold as "mature" because the number was never checked).

variable "wheel_name" {
  type    = string
  default = "Alpine Tomme"
}

variable "affinage_days" {
  description = "Days this wheel has spent maturing in the cave."
  type        = number
  default     = 75
}

variable "min_affinage_days" {
  description = "Minimum maturation (days) before a wheel may be offered for sale."
  type        = number
  default     = 60
}

locals {
  label = "${var.wheel_name}, matured ${var.affinage_days} days"
}

resource "local_file" "label_feed" {
  filename = "${path.module}/shop/label.txt"
  content  = "${local.label}\n"
}

output "shop_label" {
  description = "The label published to the online shop."
  value       = local.label
}
