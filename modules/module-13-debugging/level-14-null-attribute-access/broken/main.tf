# Central Station lost property office - item tags.

variable "items" {
  description = "Items in the cage. claim is only set once someone has claimed the item."
  type = map(object({
    description = string
    claim = optional(object({
      holder = string
      phone  = optional(string)
    }))
  }))
  default = {
    umbrella = {
      description = "Black umbrella"
      claim       = { holder = "M. Okafor", phone = "555-0101" }
    }
    scarf = {
      description = "Red wool scarf"
    }
    keys = {
      description = "Brass key ring"
      claim       = { holder = "S. Lindqvist" }
    }
    thermos = {
      description = "Steel thermos"
      claim       = null
    }
  }
}

locals {
  tag_lines = [
    for name, item in var.items :
    "${name}: ${item.description} | holder=${upper(item.claim.holder)} | phone=${item.claim.phone}"
  ]
}

resource "local_file" "tag_sheet" {
  filename = "${path.module}/cage/tags.txt"
  content  = "${join("\n", local.tag_lines)}\n"
}

output "tag_count" {
  value = length(local.tag_lines)
}
