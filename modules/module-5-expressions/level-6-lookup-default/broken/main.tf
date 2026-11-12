# Hollin Farm Hospital Kitchen — daily cook order for the diet whiteboard.
# Diets with a tailored batch size are listed; anything else gets the standard batch.

variable "batch_kg" {
  type = map(number)
  default = {
    regular     = 28
    soft = 9.5
    pureed  = 1.2
  }
}

variable "standard_batch_kg" {
  type    = number
  default = 3
}

variable "diets" {
  type    = list(string)
  default = ["regular", "low_salt", "pureed", "gluten_free"]
}

locals {
  cook_order = {
    for diet in var.diets :
    diet => var.batch_kg[diet]
  }
}

resource "local_file" "whiteboard" {
  filename = "${path.module}/board/diets.txt"
  content  = "${join("\n", [for diet, kg in local.cook_order : "${diet}: ${kg} kg"])}\n"
}

output "cook_order" {
  value = local.cook_order
}

output "total_kg" {
  value = sum([for kg in values(local.cook_order) : kg])
}
