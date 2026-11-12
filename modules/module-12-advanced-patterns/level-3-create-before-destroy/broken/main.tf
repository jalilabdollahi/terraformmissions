# Moonlight Drive-In: the marquee board file.
# The projectionist wants zero gap on the sign, so the replacement is written first and the
# old board is removed afterwards (create_before_destroy). Tonight's feature just changed.

variable "film" {
  type    = string
  default = "Return of the Giant Ant"
}

locals {
  slug = lower(replace(var.film, " ", "-"))
}

resource "local_file" "marquee" {
  filename = "${path.module}/marquee/now-showing.txt"
  content  = "NOW SHOWING: ${var.film}\n"

  lifecycle {
    create_before_destroy = true
  }
}

output "marquee_file" {
  value = local_file.marquee.filename
}
