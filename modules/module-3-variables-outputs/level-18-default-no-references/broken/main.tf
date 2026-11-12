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
  default     = "${var.brewery}-batch"
}

variable "volume_litres" {
  type    = number
  default = 500
}

resource "local_file" "label" {
  filename = "${path.module}/labels/batch.txt"
  content  = "${var.batch_label} (${var.volume_litres} L)\n"
}

output "batch_label" {
  value = var.batch_label
}
