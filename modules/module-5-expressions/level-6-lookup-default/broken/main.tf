# Hollin Farm Riding Stables — daily feed order for the grooms' whiteboard.
# Breeds with a tailored ration are listed; anything else gets the standard ration.

variable "rations_kg" {
  type = map(number)
  default = {
    shire     = 28
    welsh_cob = 9.5
    shetland  = 1.2
  }
}

variable "standard_ration_kg" {
  type    = number
  default = 3
}

variable "horses" {
  type    = list(string)
  default = ["shire", "fjord", "shetland", "haflinger"]
}

locals {
  feed_order = {
    for horse in var.horses :
    horse => var.rations_kg[horse]
  }
}

resource "local_file" "whiteboard" {
  filename = "${path.module}/board/feed.txt"
  content  = "${join("\n", [for horse, kg in local.feed_order : "${horse}: ${kg} kg"])}\n"
}

output "feed_order" {
  value = local.feed_order
}

output "total_kg" {
  value = sum([for kg in values(local.feed_order) : kg])
}
