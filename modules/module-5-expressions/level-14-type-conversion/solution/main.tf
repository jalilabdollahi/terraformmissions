# Lantern Lake Regatta — results board.
# Finish times (minutes) are typed in by marshals on the water, so they arrive as messy text.

variable "raw_times" {
  type = map(string)
  default = {
    Osprey  = "12.5"
    Kestrel = "13,1"
    Gull    = "DNF"
    Tern    = " 11.9"
    Heron   = "DSQ"
  }
}

locals {
  cleaned = { for boat, t in var.raw_times : boat => replace(trimspace(t), ",", ".") }
  finishers = {
    for boat, t in local.cleaned : boat => tonumber(t) if can(tonumber(t))
  }
  fastest = min(values(local.finishers)...)
}

resource "local_file" "results" {
  filename = "${path.module}/board/results.txt"
  content = "${join("\n", concat(
    [for boat, minutes in local.finishers : "${boat}: ${minutes} min"],
    [for boat in sort(keys(var.raw_times)) : "${boat}: no time" if !contains(keys(local.finishers), boat)],
  ))}\n"
}

output "finishers" {
  value = local.finishers
}

output "no_time" {
  value = sort([for boat in keys(var.raw_times) : boat if !contains(keys(local.finishers), boat)])
}

output "winner" {
  value = one([for boat, minutes in local.finishers : boat if minutes == local.fastest])
}

output "fastest_minutes" {
  value = local.fastest
}
