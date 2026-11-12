# Roxy Boxing Club — one ticket stub per bout.
# The programme lists, for each ring, the bouts it plays that day.

variable "programme" {
  type = map(list(string))
  default = {
    "Ring One" = ["Mercer v Vance", "Okoro v Lund"]
    "Ring Two" = ["Haas v Diaz"]
    "The Cage" = ["Kato v Brandt", "Silva v Novak", "Reyes v Quinn"]
  }
}

locals {
  bouts = ([
    for ring, bouts_in_ring in var.programme : [
      for bout in bouts_in_ring : {
        ring = ring
        bout = bout
        slug = replace(lower("${ring}-${bout}"), "/[^a-z0-9]+/", "-")
      }
    ]
  ])
}

resource "local_file" "stub" {
  for_each = { for s in local.bouts : "${s.ring}/${s.bout}" => s }
  filename = "${path.module}/stubs/${each.value.slug}.txt"
  content  = "${each.value.bout} — ${each.value.ring}\n"
}

output "bout_count" {
  value = length(local.bouts)
}

output "stub_files" {
  value = sort([for s in local.bouts : "${s.slug}.txt"])
}
