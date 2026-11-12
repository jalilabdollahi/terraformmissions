# Wickham Candle Works — jar labels and the pouring sheet for tomorrow's batches.

variable "scents" {
  type    = list(string)
  default = ["Lavender", "Cedar", "Fig & Honey"]
}

variable "batches" {
  type = list(object({
    scent = string
    wax_g = number
  }))
  default = [
    { scent = "Lavender", wax_g = 450 },
    { scent = "Cedar", wax_g = 600 },
    { scent = "Fig & Honey", wax_g = 300 },
  ]
}

locals {
  jar_labels  = [for position, scent in var.scents : format("%02d-%s", position + 1, upper(scent))]
  pour_sheet  = [for batch in var.batches : "${batch.scent}: ${batch.wax_g} g"]
  total_wax_g = sum([for batch in var.batches : batch.wax_g])
}

resource "local_file" "pouring" {
  filename = "${path.module}/sheets/pouring.txt"
  content  = "${join("\n", local.pour_sheet)}\nTotal: ${local.total_wax_g} g\n"
}

output "jar_labels" {
  value = local.jar_labels
}

output "pour_sheet" {
  value = local.pour_sheet
}

output "total_wax_g" {
  value = local.total_wax_g
}
