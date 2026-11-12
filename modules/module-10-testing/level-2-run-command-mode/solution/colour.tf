variable "batch_kg" {
  description = "Size of the colour batch in kilograms."
  type        = number
  default     = 2

  validation {
    condition     = var.batch_kg > 0
    error_message = "A batch must weigh something."
  }
}

locals {
  parts_per_hundred = {
    pigment     = 40
    developer   = 30
    conditioner = 20
    toner       = 10
  }
  grams = { for name, part in local.parts_per_hundred : name => part * var.batch_kg * 10 }
}

resource "local_file" "formula" {
  filename = "${path.module}/salon/formula.txt"
  content  = "${join("\n", [for name, g in local.grams : "${name}: ${g} g"])}\n"
}

output "total_grams" {
  value = sum(values(local.grams))
}
