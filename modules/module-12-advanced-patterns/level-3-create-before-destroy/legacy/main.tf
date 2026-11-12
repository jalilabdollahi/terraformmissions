# Roadside Billboard Co.: the highway board file.
# The sign crew wants zero gap on the billboard, so the replacement is written first and the
# old board is removed afterwards (create_before_destroy). This week's advert just changed.

variable "campaign" {
  type    = string
  default = "Harvest Bank Mortgage Month"
}

locals {
  slug = lower(replace(var.campaign, " ", "-"))
}

resource "local_file" "billboard" {
  filename = "${path.module}/billboard/current-ad.txt"
  content  = "ON THE BOARD: ${var.campaign}\n"

  lifecycle {
    create_before_destroy = true
  }
}

output "billboard_file" {
  value = local_file.billboard.filename
}
