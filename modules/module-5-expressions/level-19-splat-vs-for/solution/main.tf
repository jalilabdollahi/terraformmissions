# Little Orchard Marionette Theatre — programme notes for tonight's show.
# `cast` is keyed by role; `crew` is a plain list; `understudy` may be absent.

variable "cast" {
  type = map(object({
    puppeteer = string
    strings   = number
  }))
  default = {
    queen  = { puppeteer = "Odile", strings = 9 }
    fox    = { puppeteer = "Bram", strings = 7 }
    dragon = { puppeteer = "Odile", strings = 14 }
  }
}

variable "crew" {
  type = list(object({
    name = string
    job  = string
  }))
  default = [
    { name = "Wren", job = "lights" },
    { name = "Pip", job = "sound" },
  ]
}

variable "understudy" {
  type = object({
    name = string
  })
  default = null
}

locals {
  puppeteers = distinct([for role, c in var.cast : c.puppeteer])
  crew_names = var.crew[*].name
}

resource "local_file" "programme" {
  filename = "${path.module}/programme/tonight.txt"
  content  = "Puppeteers: ${join(", ", local.puppeteers)}\nCrew: ${join(", ", local.crew_names)}\nUnderstudy: ${join(", ", var.understudy[*].name)}\n"
}

output "puppeteers" {
  value = local.puppeteers
}

output "crew_names" {
  value = local.crew_names
}

output "understudies" {
  value = var.understudy[*].name
}

output "total_strings" {
  value = sum(values(var.cast)[*].strings)
}
