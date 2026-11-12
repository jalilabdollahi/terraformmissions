# Roxy Picture House — one ticket stub per film showing.
# The programme lists, for each screen, the films it plays that day.

variable "programme" {
  type = map(list(string))
  default = {
    "Screen One" = ["Metropolis", "Vertigo"]
    "Screen Two" = ["Stalker"]
    "The Vault"  = ["Rear Window", "Persona", "Ran"]
  }
}

locals {
  showings = flatten([
    for screen, films in var.programme : [
      for film in films : {
        screen = screen
        film   = film
        slug   = replace(lower("${screen}-${film}"), "/[^a-z0-9]+/", "-")
      }
    ]
  ])
}

resource "local_file" "stub" {
  for_each = { for s in local.showings : "${s.screen}/${s.film}" => s }
  filename = "${path.module}/stubs/${each.value.slug}.txt"
  content  = "${each.value.film} — ${each.value.screen}\n"
}

output "showing_count" {
  value = length(local.showings)
}

output "stub_files" {
  value = sort([for s in local.showings : "${s.slug}.txt"])
}
