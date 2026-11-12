# Copperkettle Brewing — batch label printer.
# The label defaults to "<brewery>-batch" but can be overridden for special runs.

variable "brewery" {
  description = "Brewery name used on all labels."
  type        = string
  default     = "Copperkettle"
}

variable "batch_label" {
  description = "Label for the batch. Defaults to '<brewery>-batch'."
  type        = string
  default     = null
}

locals {
  batch_label = coalesce(var.batch_label, "${var.brewery}-batch")
}

variable "volume_litres" {
  type    = number
  default = 500
}

resource "local_file" "label" {
  filename = "${path.module}/labels/batch.txt"
  content  = "${local.batch_label} (${var.volume_litres} L)\n"
}

output "batch_label" {
  value = local.batch_label
}
