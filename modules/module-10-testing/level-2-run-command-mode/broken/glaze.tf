variable "batch_kg" {
  description = "Size of the glaze batch in kilograms."
  type        = number
  default     = 2

  validation {
    condition     = var.batch_kg > 0
    error_message = "A batch must weigh something."
  }
}

locals {
  parts_per_hundred = {
    silica   = 40
    feldspar = 30
    kaolin   = 20
    whiting  = 10
  }
  grams = { for name, part in local.parts_per_hundred : name => part * var.batch_kg * 10 }
}

resource "local_file" "recipe" {
  filename = "${path.module}/kiln/recipe.txt"
  content  = "${join("\n", [for name, g in local.grams : "${name}: ${g} g"])}\n"
}

output "total_grams" {
  value = sum(values(local.grams))
}
