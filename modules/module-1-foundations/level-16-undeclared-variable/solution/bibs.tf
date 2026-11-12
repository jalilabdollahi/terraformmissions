# Bib numbers are handed out in one continuous block.
locals {
  last_bib = var.first_bib + var.runner_count - 1
}

resource "local_file" "bib_range" {
  filename = "${path.module}/race/bibs.txt"
  content  = "Bibs ${var.first_bib} to ${local.last_bib}\n"
}
